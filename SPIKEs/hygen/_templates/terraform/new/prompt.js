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
