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

Invoke-Expression "docker run -it -v /$DockerPwd/config/ics.conf:/home/oracle/ics.conf -v /dev/urandom:/dev/random -v /$DockerPwd/files:/tmp/files $TempFileVolumes ninckblokje/icsea-base:$ImageVersion /home/oracle/icsea/ICSOP/data/user_projects/domains/compact_domain/bin/startWebLogic.sh"