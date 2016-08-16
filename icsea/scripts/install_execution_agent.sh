#!/bin/bash

# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

INSTALL_DIR=/tmp/icsea
INSTALL_FILES_DIR=/tmp/files
TARGET_DIR=/home/oracle/icsea

sudo chmod -R 777 /tmp
sudo chown -R oracle:dba $INSTALL_DIR

echo Loading properties
. $HOME/ics.conf

echo Extracting and installing ICS Execution Agent
unzip $INSTALL_FILES_DIR/ics_exec_agent_installer_*.zip -d $INSTALL_DIR

cd $INSTALL_DIR
chmod u+x $INSTALL_DIR/ics-executionagent-installer.bsx
$INSTALL_DIR/ics-executionagent-installer.bsx <<EOF
$ICS_URL
$ICS_USERNAME
$ICS_PASSWORD


$AGENT_NAME
$TARGET_DIR
oracle
dba
$AGENT_PASSWORD
JavaDB
EOF

/home/oracle/icsea/ICSOP/data/user_projects/domains/compact_domain/bin/stopWebLogic.sh
