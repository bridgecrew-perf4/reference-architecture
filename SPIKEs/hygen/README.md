# Hygen

## Bottom Line

Hygen is a code template generator

## Major Considerations

Very limited documentation around anything outside of Redux, React and Express. All templates use embedded JavaScript. Even though its just a templating engine I was not able to find any threads online regarding people using this for Terraform.

## Spike Questions

- Is this to just provide people with a basic DIR structure such as (terraform/account, terraform/applications, terraform/bootstrap)? If so, why is this so hard without a template engine? 
- Do new teams that come on to the SBA even know about the reference architecture repository? 
  - As someone new on the team, I will say at first glance of looking at this repository its not obvious whats in this repository.
  - Its also not obvious what Terraform modules IAS has made and how to find them (thinking about the perspective of a new devops engineer on an SBA team)
  - Feels like there is a process problem
  - What would it look like / take to ensure IAS is more involved in a new teams on boarding
  - I think this repository needs some clean up / root README.md work
- Is this tool more so geared towards teams that do not have OPS engineers?

## How It Works

1. You need to initialize the Hygen generator which will provide you with a base terraform directory that you can start populating with ejs templates. These templates contain a ```to``` block to indicate the folder structure Hygen should populate.
   ```
   hygen init self
   ```

2. Create a new project using Hygen generator. To do so, run the command below which will provide you with a base terraform directory that you can start populating with ejs templates. These templates contain a ```to``` block to indicate the folder structure Hygen should populate.
   ```
   hygen generator new terraform
   ```

3. Once you have populated the .ejs.t files in your root directory you can run the command below which will create your directory with the files based on the ejs.
   ```
   hygen terraform new
   ```

4. You should now have the following directory structure
   ```
   -rw-rw-r--. 1 root root 1206 Apr 30 09:08 README.md
   drwxrwxr-x. 5 root root   53 Apr 30 09:42 _templates
   drwxrwxr-x. 5 root root   57 Apr 30 09:38 terraform
   ```

### Variables

Variables can be assigned in the template as such

  ```
  ---
  to: terraform/account/locals.tf
  ---
  locals {
    account_ids = {
      lower = "<%= locals.lower_account %>" # TODO: replace lower account_id and optionally rename `lower` to match your desired workspace
      upper = "<%= locals.upper_account %>"# TODO: repeat above step
    }
  }
  ```

You can pass the environment variable into the command line as such, however, this seems to be not a good strategy as you could imagine having 20+ vars to input into the CLI this would become more tedious than running a mkdir on a few directories and sourcing modules in my opinion.

  ```
  hygen terraform new --lower_account 12345678 --upper_account 987654321
  ```

To create prompts you need to add a prompt.js file to the root of the generator that you created and add the variables you want Hygen to prompt the user for.
  ```
  module.exports = [
  {
    type: 'input',
    name: 'lower_account',
    message: "Input your lower_account ID"
  },
  {
    type: 'input',
    name: 'upper_account',
    message: "Input your upper_account ID"
  },
  {
    type: 'input',
    name: 'cidr',
    message: "Input your VPC CIDR"
  },
  {
    type: 'input',
    name: 'public_cidr_one',
    message: "Input your CIDR for the first public subnet"
  },
  {
    type: 'input',
    name: 'public_cidr_two',
    message: "Input your CIDR for the second public subnet"
  },
  {
    type: 'input',
    name: 'private_cidr_one',
    message: "Input your CIDR for the first private subnet"
  },
  {
    type: 'input',
    name: 'private_cidr_two',
    message: "Input your CIDR for the second private subnet"
  }
  ]
  ```
