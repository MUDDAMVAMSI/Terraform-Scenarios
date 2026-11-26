# Why are Provisioners not recommended?

Terraform documentation recommends using provisioners only as a last resort.

Why?
1. Terraform cannot fully track or manage the changes made inside the server by provisioner commands.
2. If a script fails, Terraform may mark the resource as tainted (requiring replacement) after a creation-time provisioner failure.
3. Provisioners can make deployments difficult to troubleshoot and reproduce.
4. SSH connectivity and credentials introduce additional complexity.

**Scenario-based interview questions**

| No. | Interview Scenario | Expected Concept |
|---|---|---|
| 1 | You created EC2 using Terraform. How will you install Nginx automatically? | `remote-exec` / User Data |
| 2 | You have a configuration file locally. How will you copy it to EC2? | `file` |
| 3 | You created EC2 and want to execute a shell script on your local machine. | `local-exec` |
| 4 | Before deleting EC2, you want to execute a cleanup command. | Destroy-time provisioner |
| 5 | Your remote-exec provisioner fails because SSH is not connecting. What will you check? | Connection configuration |
| 6 | Your provisioner script failed after EC2 creation. What happens? | Resource failure and taint/replacement behavior |
| 7 | Why do we avoid using provisioners in production? | Maintainability and reliability |
| 8 | Instead of remote-exec, what can you use to install software during EC2 launch? | User Data / cloud-init |