$ImageVersion="160506.1920"

$DockerPwd=$PWD.path
$DockerPwd=$DockerPwd.Replace('\','/')
$DockerPwd=$DockerPwd.Substring(0,1).ToLower() + $DockerPwd.Substring(2)

Write-Host Creating Docker image [ninckblokje/icsea:$ImageVersion] from directory [$DockerPwd] 

Write-Host Building image
docker build -t ninckblokje/icsea-ph1:$ImageVersion icsea

Write-Host Running install
#docker run -it -v /$DockerPwd/files:/tmp/files -v /$DockerPwd/temp_files:/tmp/icsea/ICSOPInstall/tmp ninckblokje/icsea-ph1:$ImageVersion /tmp/scripts/install_execution_agent.sh

docker run -it -v /$DockerPwd/files:/tmp/files -v /$DockerPwd/temp_files:/tmp/icsea/ICSOPInstall/tmp ninckblokje/icsea-ph1:$ImageVersion bash