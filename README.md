# Docker image for Integration Cloud Execution Agent

!! This Docker container is of early beta quality !!

This project provides the sources to build a Docker image for the Execution Agent of the Oracle Integration Cloud. The main setup file must be downloaded manually before the image can be build.

During the creation of the Docker image to the main setup file is executed and will download additional setup files. Because of this the build process will take quite some time.

The Docker image is based upon Oracle Linux 6.8 and will install **sudo**, **tar** and **unzip**. The software will run as user **oracle**, which can execute commands as user **root** through **sudo** without a password!

I doubt that Oracle will support the Docker container :)

## Folder structure

- assets
  - Contains images for **README.md**
- config
  - Should contain the **ics.conf** file
  - Contains an example file **ics.conf.example**
- files
  - The main setup file should be put here
- iscea
  - The Docker configuration and install scripts are stored here
- temp_files
  - Can optionally store the other files to speedup the build process, otherwise these will be downloaded by the main setup file

## Download Execution Agent

The Execution Agent can be downloaden from within the Integration Cloud:

1. Login to the Oracle Cloud
2. Go to the Integration Cloud console
3. Click on **Designer**
4. Click on **Agents**
5. Click on the button **Download Agent Installer** and select **Execution Agent**

![Download Execution Agent](assets/download_icsea.png)

## Configuration

Create the file **ics.conf** based upon the file **ics.conf.example** in the **config** folder. Set the following properties:

- ICS_URL
  - Configure the identity domain and data centre
- ICS_USERNAME
  - The ICS username
- ICS_PASSWORD
  - The corresponding ICS password
- AGENT_NAME
  - The name for the execution agent
- AGENT_PASSWORD
  - The password for the execution agent

## Build instructions

If you build the Docker image on Windows make sure that the Docker VM has 5 GB or more RAM!

On Windows a PowerShell script will build the container, but will not tag it:

    $ .\Build-DockerContainer.ps1 

The container must be tagged manually. First retrieve the container id, then tag it:

    $ docker ps -a
    $ docker commit [CONTAINER_ID] ninckblokje/icsea:160506.192

The Oracle software itself is not installed while building the container (since sending the multi gigabyte binaries to the daemon will take quite some time). But is installed in the first run (which is done by the script **Build-DockerContainer.ps1**). The build step will generate a container image named **ninckblokje/icsea-base**.

## Run the container

Running the container can be done easily using this command:

    $ Invoke-Expression "docker run -it -v /dev/urandom:/dev/random  ninckblokje/icsea:$ImageVersion /home/oracle/icsea/ICSOP/data/user_projects/domains/compact_domain/bin/startWebLogic.sh"

## Save install files

To save time it is possible to provide the install files manually. Normally the main setup file will download these files, but it is possible to copy them out of the container. Put them in the **temp_files** folder. During the next build this folder is mounted and the main setup file will not download these files, but will use these files.

The following files can be stored here:

- 0.160506.1920_jdk-7u55-fcs-bin-b13-linux-x64-17_mar_2014.tar.gz
- 0.160506.1920_wls_jrf_generic.jar
- ics_generic.jar (not sure)
- ics_generic.zip
- wlspatches.zip

To copy the files out of the container use this command:

    $ docker cp [CONTAINER]:/tmp/icsea/ICSOPInstall/tmp/[FILE] [PWD]/temp_files/[FILE]

## Random number generator

WebLogic requires a large number of entropy from **/dev/random**. If it runs out of entropy then WebLogic becomes very very slow. To fix this either the **rng** daemon can be used, but on a Docker container that is quite hard since the kernel from the host system is used. To fix this **/dev/urandom** is mounted using a volume to **/dev/random** on the container.

For more information take a look at metalink document 1997349.1, [Using the Random Number Generator](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Security_Guide/sect-Security_Guide-Encryption-Using_the_Random_Number_Generator.html) and [Stack Overflow](http://stackoverflow.com/questions/26021181/not-enough-entropy-to-support-dev-random-in-docker-containers-running-in-boot2d).
