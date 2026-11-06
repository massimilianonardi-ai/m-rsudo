#!/usr/bin/env python3
"""Drive the real installed rsudo-admin main menu through a disposable PTY.

No credential group is configured: selecting Browse host must return to the
real menu with an explanatory message, without opening SSH or invoking sudo.
This script drives terminal input only; it does not replace product functions.
"""

import errno
import fcntl
import os
import pty
import re
import select
import signal
import struct
import sys
import termios
import time

ANSI = re.compile(rb"\x1b\[[0-?]*[ -/]*[@-~]")


def main():
    pid, master = pty.fork()
    if pid == 0:
        os.environ["TERM"] = "xterm"
        os.execvp("rsudo-admin", ["rsudo-admin"])

    data = bytearray()
    stage = 0
    result = None
    deadline = time.monotonic() + 25
    try:
        fcntl.ioctl(master, termios.TIOCSWINSZ, struct.pack("HHHH", 35, 110, 0, 0))
        while time.monotonic() < deadline:
            ready, _, _ = select.select([master], [], [], 0.2)
            if ready:
                try:
                    chunk = os.read(master, 16384)
                except OSError as exc:
                    if exc.errno != errno.EIO:
                        raise
                    chunk = b""
                if chunk:
                    data.extend(chunk)

            display = ANSI.sub(b"", bytes(data))
            if stage == 0 and b"Browse host" in display:
                os.write(master, b"\x1b[B\r")
                stage = 1
            elif stage == 1 and b"No credential hosts are loaded in memory." in display:
                os.write(master, b"\x1b")
                stage = 2

            finished, status = os.waitpid(pid, os.WNOHANG)
            if finished == pid:
                result = status
                break

        if result is None:
            raise RuntimeError("real rsudo-admin did not finish before PTY deadline")
        if stage != 2:
            raise RuntimeError("real rsudo-admin did not complete no-credentials Browse host")
        if not os.WIFEXITED(result) or os.WEXITSTATUS(result) != 0:
            raise RuntimeError("rsudo-admin failed to exit cleanly after Escape")
        print("PASS: real rsudo-admin PTY Browse host without credentials and Escape")
        return 0
    except Exception as exc:
        print("FAIL: " + str(exc), file=sys.stderr)
        print(ANSI.sub(b"", bytes(data))[-5000:].decode("utf-8", "replace"), file=sys.stderr)
        return 1
    finally:
        if result is None:
            try:
                os.killpg(pid, signal.SIGTERM)
            except ProcessLookupError:
                pass
            try:
                os.waitpid(pid, 0)
            except ChildProcessError:
                pass
        os.close(master)


if __name__ == "__main__":
    sys.exit(main())
