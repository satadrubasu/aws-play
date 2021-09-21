### Steps [ codecommit with ssh ]

1. Create a key pair :
  ```
  cd ~/.ssh
  ssh-keygen -t rsa -b 2048 -C "aws-codecommit"
  EnterFilename to store the key pair --> "aws-codecommit"
  ```

2. Upload the public key agaisnt the IAM User.
 IAM --> Users --> <user> -->SSH keys for AWS CodeCommit :
   
  - capture the SSH Key ID [ to be used as User in next step ]

3. Update config file to point sshkey-id and private key file on the system :
  
vi ~/.ssh/config
```
Host git-codecommit.*.amazonaws.com
  User <SSH-KEY-ID>
  IdentityFile ~/.ssh/aws-codecommit 
```
