# B-DOP-500-PAR-5-1-whanos-alexandre.jublot

## Prerequisite:
- If you use ssh access for your hosts, make sure they use the same ssh private key to connect
- If they are different you MUST add them to you ssh agent (refer to ssh documentation)
- All your machines MUST run **ubuntu** linux distribution !
- You MUST open the **port 25000** on you master machine !
- Only use **http** protocol for repositories in Jenkins !

## Config Ansible:
- First go to the deployement folder: 
```
cd deployement/
```
- Then you must specify your hosts on which you want to deploy whanos tool
- Open ```inventory.cfg``` with any text editor
- You have to specify at least a master server by changing *[whanos-master]*, E.g.:
```
[whanos-master]
master ansible_host=USERNAME@YOUR_HOST_PUBLIC_IP
```
- You have to specify at least one worker server by changing *[whanos-nodes]*, E.g.:
```
[whanos-nodes]
worker1 ansible_host=USERNAME@YOUR_WORKER_PUBLIC_IP
```

## Config Jenkins:
- Generate a base64 password with the following command (copy the exact entire output):
```
echo -n "YOUR_PASSWORD"
```
- Open the kubernetes/whanos/values.yaml file with any text editor and pase your base64 password at the line **adminpassword:**: 
```
jenkins:
  # the repository to pull the jenkins image created by docker build . (at the root of the repo)
  image: localhost:32000/whanos-jenkins
  # the password has to be encoded in base64
  adminpassword: YOUR_COPIED_BASE64_PASSWORD
```

## Install tool:
- Move in the deployement folder 
```
 cd deployement/
 ```
  - If your key(s) are registered, simply execute the following command
```
ansible-playbook playbook.yml -i inventory.cfg
```
 - If you are using ssh hosts and have not registered your ssh key in your agent, execute the following command:
 ```
 ansible-playbook playbook.yml -i inventory.cfg --private-key PATH/TO/PRIVATE_KEY_FILE
 ```
 - You MUST use the SAME key for all hosts in this case
 - Usually you have set your key in:
 ```
 /home/USER/.ssh/KEY_FILE
 ```

## Run Jenkins:
- After installing the tool, you should see this as last step output:
```
TASK [log-info : Finished, use next step] 
ok: [master] => {
    "msg": "Use your master IP with this port: 'PORT', in your browser to open jenkins interface."
}
```
- Make sure you have openned the *PORT* given in this output on your master machine !
- Then open your web browser and enter your master host *IP* followed by the *PORT* given in this last output.
- You should now see the jenkins login page. 

## Jenkins - Initialization
- Once logged in in Jenkins you should see a dash board with different folders
- First click on Whanos-build folder
- Click on the green play button on the row 'Build all base images'
- Then go back to the dashboard (top-left button with the same name)


## Jenkins - Add a project
- Click on the green play button on the row 'link-project'
- Enter your project repository url (http only, no ssh url)
- Enter you project display name
- You can now access and run your project from the 'Project' folder on the dashboard

