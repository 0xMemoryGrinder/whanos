# B-DOP-500-PAR-5-1-whanos-alexandre.jublot

## Prerequisite:
- If you use ssh access for your hosts, make sure they use the same ssh private key to connect
- If they are different you MUST add them to you ssh agent (refer to ssh documentation)
- All your machines must run **ubuntu** linux distribution

## Config:
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
- Then open your web browser and enter your master host *IP* followed by the *PORT* given in this last output.
- You should now see the jenkins login page. 

