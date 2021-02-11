# Fargate Wordpress + EFS

## Bottom Line

It appears possible to run WordPress in a Fargate+EFS setting, but it is unclear at this point what the long term implications are of using `wordpress:latest` image. It is also unclear how push-button upgrades will affect the installation living on the EFS mount point.


## Spike Questions

* Is it possible to spin-up multiple Fargate instances with a sinlge EFS attached?
  - Yes - in the example we are running 2 instnaces.
  - It also may be a good idea when running more then 1 instance to use the following environment variables as to not cause a race condition during the initial wordpress installation on EFS as they will be randomy generated.
    - WORDPRESS_AUTH_KEY
    - WORDPRESS_AUTH_SALT
    - WORDPRESS_SECURE_AUTH_KEY
    - WORDPRESS_SECURE_AUTH_SALT
    - WORDPRESS_LOGGED_IN_KEY
    - WORDPRESS_LOGGED_IN_SALT
    - WORDPRESS_NONCE_KEY
    - WORDPRESS_NONCE_SALT

* What does it look like to upgrade the wordpress installation?
  - At this point it unknown, further testing will need to be done.

* Is there a way to use the `:latest` WordPress container?
  - Possibly, but further exploration will need to done in order to give a valid answer.
