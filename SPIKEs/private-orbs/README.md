# Circle CI // Private Orbs

## Where are Private Orbs useful?

Private orbs are particularly useful when an organization has a high degree of governance and compliance standards (eg. Healthcare and finance industries) providing a consistent and reusable approach across projects within the organization without having to advertise those procedures to the world.

## How do Private Orbs work?

A private orb is restricted to the organization of users, having read or write permissions respectively, to see, use or manage an orb. In general there is no difference in capability between a private and a public orb with the exception of who can use it. To demonstrate how private and public orbs are created

```
# public orbs
$ circleci orb create USSBA/cheeseburger
$ circleci orb list USSBA

# private orbs
$ circleci orb create USSBA/cheeseburger --private
$ circleci orb list USSBA --private

# publishing a development version of an orb
$ circleci orb publish /tmp/orb.yml USSBA/cheeseburger@dev:first

# publishing an offical version of an orb
$ circleci orb publish promote USSBA/cheeseburger@dev:first major|minor|patch
```

## How can the SBA take advantage of orbs?

At present many of the USSBA projects using CIRCLECI basically use a copy & paste method to perform the installation of the awscli and terraform, building docker images and pushing them to private or public ECR registries, building, packaging and caching of ruby and nodejs applications, and finally performing actions against terraform projects. It can be debated whether these orbs should be public or private, both can be beneficial. If confidentiality is preferable use private orbs, when public opinion is desired use public orbs.

## Reference Documentation

* [https://circleci.com/blog/circleci-private-orbs/](https://circleci.com/blog/circleci-private-orbs/)
* [https://circleci.com/docs/2.0/orb-intro/#private-orbs](https://circleci.com/docs/2.0/orb-intro/#private-orbs)
* [https://circleci.com/docs/2.0/orb-author-validate-publish/](https://circleci.com/docs/2.0/orb-author-validate-publish/)
* [https://circleci.com/docs/2.0/orb-author/#orb-development-kit](https://circleci.com/docs/2.0/orb-author/#orb-development-kit)

