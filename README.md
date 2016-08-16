# Docker image for Integration Cloud Execution Agent

This project provides the sources to build a Docker image for the Execution Agent of the Oracle Integration Cloud. The main setup file must be downloaded manually before the image can be build.

During the creation of the Docker image to the main setup file is executed and will download additional setup files. Because of this the build process will take quite some time.

The Docker image is based upon Oracle Linux 6.8 and will install **sudo**, **tar** and **unzip**. The software will run as user **oracle**, which can execute commands as user **root** through **sudo** without a password!

## Folder structure

- assets
  - Contains images for **README.md**
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



## Build instructions



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
