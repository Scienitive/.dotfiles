#!/usr/bin/env python3
"""
Zellij session manager
Keybinds:
  j / ctrl-n    move down
  k / ctrl-p    move up
  enter         switch to selected session (detaches current, attaches target)
  ctrl-t        new session (prompts for name, then detaches + attaches)
  ctrl-r        rename CURRENT session (prompts for new name)
  ctrl-x        delete selected session (with confirmation)
  q / esc       quit
"""

import curses
import os
import subprocess
import sys

TARGET_FILE = "/tmp/zellij-attach-target"
CURRENT_SESSION = os.environ.get("ZELLIJ_SESSION_NAME", "")


def list_sessions():
    try:
        out = subprocess.check_output(
            ["zellij", "list-sessions", "-n"],
            stderr=subprocess.DEVNULL,
            text=True,
        )
        sessions = []
        for line in out.strip().splitlines():
            name = line.split()[0] if line.strip() else None
            if name:
                sessions.append(name)
        return sessions
    except subprocess.CalledProcessError:
        return []


def detach_and_attach(session_name):
    """Write target to file then detach. Shell hook picks up the rest."""
    with open(TARGET_FILE, "w") as f:
        f.write(session_name)
    subprocess.run(["zellij", "action", "detach"])


def delete_session(name):
    subprocess.run(
        ["zellij", "delete-session", name, "--force"],
        stderr=subprocess.DEVNULL,
    )


def rename_current_session(name):
    subprocess.run(
        ["zellij", "action", "rename-session", name],
        stderr=subprocess.DEVNULL,
    )


def prompt_input(stdscr, prompt):
    """Show an input prompt at the bottom of the screen, return entered string."""
    h, w = stdscr.getmaxyx()
    stdscr.move(h - 1, 0)
    stdscr.clrtoeol()
    stdscr.attron(curses.color_pair(3))
    stdscr.addstr(h - 1, 0, prompt)
    stdscr.attroff(curses.color_pair(3))
    curses.echo()
    curses.curs_set(1)
    try:
        value = stdscr.getstr(h - 1, len(prompt), 64).decode("utf-8").strip()
    except Exception:
        value = ""
    curses.noecho()
    curses.curs_set(0)
    return value


def confirm(stdscr, message):
    h, w = stdscr.getmaxyx()
    stdscr.move(h - 1, 0)
    stdscr.clrtoeol()
    stdscr.attron(curses.color_pair(4))
    stdscr.addstr(h - 1, 0, message + " [y/N]: ")
    stdscr.attroff(curses.color_pair(4))
    stdscr.refresh()
    ch = stdscr.getch()
    return ch in (ord("y"), ord("Y"))


def draw(stdscr, sessions, selected, message):
    stdscr.clear()
    h, w = stdscr.getmaxyx()

    # Header
    header = " Zellij Sessions "
    stdscr.attron(curses.color_pair(1) | curses.A_BOLD)
    stdscr.addstr(0, 0, header.ljust(w))
    stdscr.attroff(curses.color_pair(1) | curses.A_BOLD)

    # Sessions list
    list_start = 2
    for i, name in enumerate(sessions):
        y = list_start + i
        if y >= h - 3:
            break

        is_selected = i == selected
        is_current = name == CURRENT_SESSION

        prefix = " ● " if is_current else "   "
        label = f"{prefix}{name}"
        label = label.ljust(w)

        if is_selected:
            stdscr.attron(curses.color_pair(2) | curses.A_BOLD)
            stdscr.addstr(y, 0, label[:w])
            stdscr.attroff(curses.color_pair(2) | curses.A_BOLD)
        elif is_current:
            stdscr.attron(curses.color_pair(1))
            stdscr.addstr(y, 0, label[:w])
            stdscr.attroff(curses.color_pair(1))
        else:
            stdscr.addstr(y, 0, label[:w])

    if not sessions:
        stdscr.addstr(list_start, 2, "no sessions found")

    # Status message
    if message:
        stdscr.attron(curses.color_pair(3))
        stdscr.addstr(h - 3, 0, message[:w])
        stdscr.attroff(curses.color_pair(3))

    # Footer keybinds
    footer = " enter:switch  ^t:new  ^r:rename(current)  ^x:delete  q:quit "
    stdscr.attron(curses.color_pair(1))
    stdscr.addstr(h - 1, 0, footer[:w].ljust(w))
    stdscr.attroff(curses.color_pair(1))

    stdscr.refresh()


def main(stdscr):
    curses.curs_set(0)
    curses.start_color()
    curses.use_default_colors()

    # color pairs: 1=header/footer (green on default), 2=selected (black on green), 3=info, 4=warning
    curses.init_pair(1, curses.COLOR_GREEN, -1)
    curses.init_pair(2, curses.COLOR_BLACK, curses.COLOR_GREEN)
    curses.init_pair(3, curses.COLOR_CYAN, -1)
    curses.init_pair(4, curses.COLOR_YELLOW, -1)

    sessions = list_sessions()
    # Start with cursor on current session if found
    selected = 0
    if CURRENT_SESSION in sessions:
        selected = sessions.index(CURRENT_SESSION)

    message = ""

    while True:
        draw(stdscr, sessions, selected, message)
        message = ""

        ch = stdscr.getch()

        # Movement
        if ch in (ord("j"), 14):  # j or ctrl-n
            selected = min(selected + 1, len(sessions) - 1)
        elif ch in (ord("k"), 16):  # k or ctrl-p
            selected = max(selected - 1, 0)

        # Quit
        elif ch in (ord("q"), 27):  # q or esc
            break

        # Switch session (enter)
        elif ch == 10 and sessions:
            target = sessions[selected]
            if target == CURRENT_SESSION:
                message = f"already on '{target}'"
            else:
                detach_and_attach(target)
                break

        # New session (ctrl-t)
        elif ch == 20:  # ctrl-t
            name = prompt_input(stdscr, "new session name: ")
            if name:
                with open(TARGET_FILE, "w") as f:
                    f.write(f"__new__{name}")
                subprocess.run(["zellij", "action", "detach"])
                break
            else:
                message = "cancelled"

        # Rename current session (ctrl-r)
        elif ch == 18:  # ctrl-r
            new_name = prompt_input(stdscr, f"rename '{CURRENT_SESSION}' to: ")
            if new_name:
                rename_current_session(new_name)
                # Update display name
                if CURRENT_SESSION in sessions:
                    idx = sessions.index(CURRENT_SESSION)
                    sessions[idx] = new_name
                message = f"renamed to '{new_name}'"
            else:
                message = "cancelled"

        # Delete session (ctrl-x)
        elif ch == 24 and sessions:  # ctrl-x
            target = sessions[selected]
            if confirm(stdscr, f"delete '{target}'?"):
                delete_session(target)
                sessions.pop(selected)
                selected = min(selected, len(sessions) - 1)
                message = f"deleted '{target}'"
            else:
                message = "cancelled"


if __name__ == "__main__":
    curses.wrapper(main)
