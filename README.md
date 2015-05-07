![image](https://dl.dropboxusercontent.com/u/6888621/htdocs/planet-express.png)

Planet-Express
==============

![image](https://img.shields.io/badge/version-0.1.1-brightgreen.svg)


Planet Express is a command line utility written in rubt to deploy code from git repositories.

** /!\ This project is actualy at a very early developpement stage /!\ **

Requirements
------------

- Git > 2.x
- Ruby > 2.x

Installation
------------

For now you can clone this repository and build the gem

```
git clone git@github.com:yadomi/planet-express.git
bundle install
rake install
```

Usage
-----

1. Initialize your projet with a `Planetfile`:

    ```
    planet init
    ```

    This command created a `Planetfile` at the root of the projet. You may want to edit this file to adapt to your deployment stack.

2. Setup on the remote server:

    ```
    planet setup preprod
    ```
    This command clone the repo on the remote host to the desired location.

3. Deploy !
	
	```
	planet deploy preprod
	```
	
	This command pull the lastest revision of the specified branch on the remote host and then run hooks in **deploy/**.