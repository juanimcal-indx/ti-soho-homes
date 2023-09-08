# ti-soho-homes

## TI Exercise

* Folder Structure:

```bash
.
├── bootstrap
│   └── config.sh
├── bootstrap.sh
├── README.md
├── src
│   └── zipper-function
│       ├── main.py
│       └── requirements.txt
└── terraform
    ├── app
    │   ├── deploy.sh
    │   ├── destroy.sh
    │   ├── main.tf
    │   ├── providers.tf
    │   └── variables.tf
    └── service_accounts
        ├── deploy.sh
        ├── destroy.sh
        ├── main.tf
        ├── providers.tf
        └── variables.tf
```

  - **bootstrap.sh** -> Script to configure gcloud based on parameters found in **bootstrap/config.sh**.
  - **terraform** folder contains the service accounts and app scripts.
  - **src** contains Python Code for the Cloud Function.

- Run the exercise:
  - Edit ```bootstrap/config.sh``` configuring proper values (note that i authenticate Terraform with ```GOOGLE_APPLICATION_CREDENTIALS``` env var, therefore we should have a Service Account JSON key with proper permissions for running Terraform. In my case i assigned Editor and Security Admin roles, needed for creating service accounts and bind policies)
  - Variables with preffix ```TF_VAR_``` are exported and used to populate variables in Terraform Script, is very important to add proper values for JSON key path, region, zone, project.
  - Once everything is setup on ```config.sh``` optionally you can run the ```bootstrap.sh``` script in order to create gcloud profile and configure it, this is useful if you want to run gccloud without crushing any config that you have at the moment.
  - First you should create SAs (this is the second part of the exercise but i added a 5th SA for the Cloud Function there) 
    - ```cd terraform/service_accounts/```
    - ```./deploy.sh```
  - Deploy wrapper script will source config.sh vars and run ```terraform init && terraform apply```
  - You can now deploy the Cloud Function:
    - ```cd terraform/app/```
    - ```./deploy.sh```
  - The Cloud Function will watch for the source Bucket uploads and react copying the file to the destination bucket.
  - Once you finish reviewing the exercise, just run the wrapper scripts ```destroy.sh``` for removing the resources.

- Security Considerations:
  - I tried to assign the minimum permissions needed for running the functions, you can take a look in the variables file [here](https://github.com/juanimcal-indx/ti-soho-homes/blob/d0e573c71d7023ec4bc855cc4a86c906cd95d670/terraform/service_accounts/variables.tf#L1)

