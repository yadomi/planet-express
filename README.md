![image](https://dl.dropboxusercontent.com/u/6888621/htdocs/planet-express.png)

Planet-Express
==============

![image](https://img.shields.io/badge/version-0.1.4-brightgreen.svg)

Planet Express is a command line utility written in **Ruby** to deploy code from git repositories.

**This project is under developpement. Consider this project not production-ready.**

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
    $ planet init
    ```

    This command created a `Planetfile` at the root of the projet. You may want to edit this file to adapt to your deployment stack.

2. Setup on the remote server:

    ```
    $ planet setup preprod
    ```
    This command clone the repo on the remote host to the desired location.

3. Deploy !
	
	```
	$ planet deploy preprod
	```
	
	This command pull the lastest revision of the specified branch on the remote host and then run hooks in **deploy/**.

FAQ
---

TODO
----

Statut | Task |
:-----:|------|
☑ | Add todos |
☑ | Write tests |
☐ | Keep old releases |
☐ | Auto rollback when deploy fail |

Planetfile API
--------------

###Planet.configure

- `config.branch`: the default branch to pull from the repository (default: master)
- `config.repository`: the Git SCP-style URI repository URL
- `config.key`: the private SSH key used to connect to the repository (eg: GitHub)

###Planet.target

- `server.ssh`: the deployement target using SCP Style URI.

	The last part is the path where you want to deploy your project. You can use 	absolute (eg: **/path/to/deploy/location**) or 
	or relative path. This mean that deploy/location is the same than **/home/	user/deploy/location** or **~/deploy/location**

- `server.key`: The private SSH key used to connect to the server