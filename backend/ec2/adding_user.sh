#!/bin/bash

BASTIONS=$(cat bastion-hosts.txt)
SSH_USER="ec2-user" # default SSH user to connect as (like ec2-user or ubuntu)
KEY_PATH="/path/to/your/private/key.pem"
PUBKEY_DIR="./pubkeys"

for HOST in $BASTIONS; do
  echo "Connecting to $HOST..."
  for PUBKEY in $PUBKEY_DIR/*.pub; do
    NEW_USER=$(basename "$PUBKEY" .pub)
    KEY_CONTENT=$(cat "$PUBKEY")

    echo "Creating user '$NEW_USER' on $HOST if not exists..."
    
    ssh -i "$KEY_PATH" -o StrictHostKeyChecking=no "$SSH_USER@$HOST" bash <<EOF
      # Check if user exists
      id "$NEW_USER" &>/dev/null
      if [ \$? -ne 0 ]; then
        sudo useradd -m -s /bin/bash "$NEW_USER"
        echo "User '$NEW_USER' created"
      else
        echo "User '$NEW_USER' already exists"
      fi

      # Setup SSH directory
      sudo mkdir -p /home/"$NEW_USER"/.ssh
      sudo touch /home/"$NEW_USER"/.ssh/authorized_keys
      sudo chown -R "$NEW_USER":"$NEW_USER" /home/"$NEW_USER"/.ssh
      sudo chmod 700 /home/"$NEW_USER"/.ssh
      sudo chmod 600 /home/"$NEW_USER"/.ssh/authorized_keys

      # Check if key already exists
      grep -qF "$KEY_CONTENT" /home/"$NEW_USER"/.ssh/authorized_keys
      if [ \$? -ne 0 ]; then
        echo "$KEY_CONTENT" | sudo tee -a /home/"$NEW_USER"/.ssh/authorized_keys > /dev/null
        echo "Key added for $NEW_USER"
      else
        echo "Key already exists for $NEW_USER"
      fi
EOF

  done
done

