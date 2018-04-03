# Goldenseal -- _Hydrastis canadensis_
[![Build Status](https://travis-ci.org/curationexperts/goldenseal.svg?branch=master)](https://travis-ci.org/curationexperts/goldenseal)

<img src="https://upload.wikimedia.org/wikipedia/commons/6/65/Hydrastis_canadensis_-_K%C3%B6hler%E2%80%93s_Medizinal-Pflanzen-209.jpg" height="300" style="float: right">

## Development Installation

### Prerequisites:

* Goldenseal relies on [hydra-derivatives](https://github.com/projecthydra/hydra-derivatives) for derivative processing and needs the [required dependencies](https://github.com/projecthydra/hydra-derivatives#dependencies) installed
* redis
* java 8

### Setup:

* Clone the code from this repo (Note: if using a vagrant vm as a dev environment, clone the code into the vagrant user's home directory, /home/vagrant/)
* Move into the root of the project (e.g. `cd ~/goldenseal`) and execute these four commands:

```
bin/setup
rake jetty:clean
rake curation_concerns:jetty:config
rake jetty:start
```

### Config:

* By default, goldenseal offers Text, Audio, Document, Image, and Video works. If you want different work types, configure those in ```config/initializers/curation_concerns.rb```
* Goldenseal uses ldap for authentication and authorization. Set your config/ldap.yml to connect to an openldap or ActiveDirectory server. Admin users must be members of a group called "admin". 

## Background Jobs

To start the redis server:
```
redis-server /usr/local/etc/redis.conf
```

To see the status of recent jobs in the browser console:
```
resque-web -N curation_concerns:development
```

To start worker(s) to run the jobs:
```
QUEUE=* VERBOSE=1 rake resque:work
```

## Run the test suite

* Make sure jetty is running
* `bundle exec rake spec`

## Run the rails server

* Make sure jetty is running
* Make sure redis is running
* `bin/rails s`

## Production Installation

We recommend using Ansible to create production instances of Goldenseal. Download https://github.com/acozine/sufia-centos/releases/tag/0.1 and symlink the roles subdirectory of the sufia-centos code into the ansible subudirectory of the Goldenseal code:
```
sudo ln -s /path/to/sufia-centos/roles /path/to/goldenseal/ansible/roles
```
Review/modify ansible/ansible_vars.yml. If you're not creating your server on EC2, comment out the launch_ec2 and ec2 roles in ansible/ansible-ec2.yml, boot your server, add your public key to the centos user's authorized_keys file, add a disk at /opt if desired, then run the ansible scripts with:
```
ansible-playbook ansible/ansible-ec2.yml --private-key=/path/to/private/half/of/your/key
```

### Versions:

We have tested Goldenseal with the following versions of its dependencies:

* CentOS 7.0
* Ruby 2.2.3
* Java 1.8.0_51
* Tomcat 7.0.54-2.el7_1 (via yum)
* Fedora (fcrepo) 4.4.0
* Solr 4.10.4
* Postgresql 9.2.13-1.el7_1 (via yum)
* Apache (httpd) 2.4.6-31.el7.centos.1 (via yum)
* Passenger 5.0.10 (as a gem)
* FITS 0.8.4
* ImageMagick 6.9.2-5 with
	* libpng-1.6.18
	* openjpeg-2.1.0
	* tiff-4.0.5

## Importing Records
### Importing records with TEI or VRA files

TEI files can be parsed to create Audio, Video, or Text records.  VRA records can be parsed to produce Image records.  The instructions are basically the same either way.

* Create a directory and add all the TEI (or VRA) files to that directory.
* Add all the attached files to the same directory.  You can organize them in sub-directories if you wish; They don't need to be in the top-level directory.
* From within the Rails root directory, run the import script. (See notes below)
* Log in to the application as an admin user, and click the "Jobs" link in the drop-down menu.  The importer will queue background jobs to ingest and characterize the files.  Monitor the "failed" jobs section to make sure there weren't any failures while processing the imported files.  If there are failed jobs, you may need to re-run the jobs, or if there's an issue that needs to be fixed, delete the newly-imported record(s), fix the issue, and re-run the importer.

```
script/import -t TYPE -p PATH -v [VISIBILITY] -a [ADMIN_SET_ID]
```

| Argument | Description | Requirement |
| --- | --- | --- |
| -t | The type of record(s) to create.  Valid options are: ["Text", "Video", "Audio", "Image"]. | required |
| -p | The path to the directory where the TEI or VRA files are located. | required |
| -v | The visibility level that the imported records will have.  Valid options are: ["open", "institution", "private"].  Default value will be "private" if no option is given. | optional |
| -a | The ID for the AdminSet that the imported records will belong to.  If no option is given, the imported records will not belong to any AdminSet. | optional |
| -h | Help: Print usage message for this script | optional |

**Note:**  The TEI files must be at the top level of the directory and must have a `.xml` file extension.  The importer will assume that any XML files found in the top-level directory are TEI files, and try to parse them.  The same is true for VRA records.

**Note:** Visibility cannot be set to `embargo` or `lease` using this script.  If you want to create a record with an embargo or lease, please import the record with `private` visibility, then edit the record using the UI to set the embargo manually.

To see the list of IDs for all AdminSets, run the rake task:

```
rake admin_set:list
```

## File System Cleanup

### tmp/uploads under Rails root dir

The `tmp/uploads` directory is where uploaded files are temporarily stored before they are ingested into fedora.  This directory will continue to grow forever, so we recommend that you write a cron job to periodically clean it out and/or set up disk space monitoring.

You must be sure that all the background jobs have finished using the files before you delete them, so rather than deleting everything under `tmp/uploads`, we recommend that you only delete files and directories that are more than a few days old.

For a little more background [see story #199](https://github.com/curationexperts/goldenseal/issues/199)

## Spotlight Notes
### Workflow
- Create Spotlight Exhibits from all Admin Sets
- Update search of index CC works to work with SL Exhibits
- autocomplete
  - Set autocmplete_default_param in new Spotlight initializer
- Associate AdminSet to Exhibit
- Add "spotlight_exhibit_slug_xxxxxxx_bsi" to solr_params for works when associated to collection
