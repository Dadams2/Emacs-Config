#!/usr/bin/env python3
from pathlib import Path
from dataclasses import dataclass, asdict
from typing import List
import json
import shutil
import os


mbsyncFile = Path("~/.mbsyncrc").expanduser()
msmtpFile = Path("~/.msmtprc").expanduser()
default_port = 587
field_map = {
    "name": "account",
    "host": "host",
    "port": "port",
    "from_address": "from",
    "user": "user",
    "password_expression": "passwordeval",
}

msmtpDefaults = {
    "defaults": "",
    "auth": "on",
    "tls": "on",
    "tls_trust_file": "/etc/ssl/certs/ca-certificates.crt",
    "logfile": "~/.msmtp.log",
}


def export_defaults(defaults):
    return "\n".join(f"{field:<20}{value}" for field, value in msmtpDefaults.items())


@dataclass(init=False)
class MsmtpAccount:
    name: str = ""
    host: str = ""
    port: int = 0
    from_address: str = ""
    user: str = ""
    password_expression: str = ""

    def export(self):
        return "\n".join(
            [f"{field_map[field]:<20}{value}" for field, value in asdict(self).items()]
        )


accounts: List[MsmtpAccount] = []


def parse_mbsync_file():
    cur = None
    with open(mbsyncFile, "r") as f:
        for line in f:
            if line.startswith("IMAPAccount"):
                cur = MsmtpAccount()
                cur.name = line.strip().split()[1]
                cur.port = default_port
            if line.startswith("Host"):
                cur.host = line.strip().split()[1].replace("imap", "smtp")
            if line.startswith("User"):
                cur.from_address = line.strip().split()[1]
                cur.user = cur.from_address.split("@")[0]
            if line.startswith("PassCmd"):
                cur.password_expression = " ".join(line.strip().split()[1:])
                accounts.append(cur)


def write_file():
    with open(msmtpFile, "w") as f:
        f.write(export_defaults(msmtpDefaults) + "\n\n")
        for acct in accounts:
            if acct != None:
                print(acct.name)
                f.write(acct.export() + "\n\n")
        f.write(f"account default : {accounts[0].name}")


def main():
    print("\033[1;34m:: MbSync to msmtp config file creator ::\033[0;37m")

    shutil.move(msmtpFile, msmtpFile.with_suffix(".old"))
    print("\033[1;30msmtp config file moved to .msmtprc.old\033[0;37m")

    parse_mbsync_file()
    write_file()
    print("\033[1;34m Complete \033[0;37m")


if __name__ == "__main__":
    main()
