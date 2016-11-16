<#
    Copyright (c) 2016, ninckblokje
    All rights reserved.
    
    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:
    
    * Redistributions of source code must retain the above copyright notice, this
      list of conditions and the following disclaimer.
    
    * Redistributions in binary form must reproduce the above copyright notice,
      this list of conditions and the following disclaimer in the documentation
      and/or other materials provided with the distribution.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
    AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
    IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
    FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
    DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
    SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
    CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
    OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
    OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#>

$ImageVersion="160506.1920"

$DockerPwd=$PWD.path
$DockerPwd=$DockerPwd.Replace('\','/')
$DockerPwd=$DockerPwd.Substring(0,1).ToLower() + $DockerPwd.Substring(2)

Write-Host Creating Docker image [ninckblokje/icsea:$ImageVersion] from directory [$DockerPwd]

$TempFileVolumes=""
Get-ChildItem "$PWD\temp_files" | 
Foreach-Object {
    $TempFile=$_.FullName
    $TempFile=$TempFile.Replace('\','/')
    $TempFile=$TempFile.Substring(0,1).ToLower() + $TempFile.Substring(2)
    
    $TempName=$_.Name
    
    Write-Host Found temp install file [$TempFile]
    $TempFileVolumes=$TempFileVolumes + " -v /${TempFile}:/tmp/icsea/ICSOPInstall/tmp/$TempName"
}

Write-Host Building image
docker build -t ninckblokje/icsea-base:$ImageVersion icsea

Write-Host Running install

Invoke-Expression "docker run -it -v /$DockerPwd/config/ics.conf:/home/oracle/ics.conf -v /dev/urandom:/dev/random -v /$DockerPwd/files:/tmp/files $TempFileVolumes ninckblokje/icsea-base:$ImageVersion /tmp/scripts/install_execution_agent.sh"