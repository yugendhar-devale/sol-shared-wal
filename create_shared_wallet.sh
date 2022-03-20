#!/bin/zsh

echo "Shared Wallet"
url="http://localhost:8899"
solana config set --url $url

# Shared wallet between 3 friends
echo "creating the keypairs for the multisig"
for i in {1..3}
do
    solana-keygen new --no-bip39-passphrase -o signer${i}.json;
done

signer1=signer1.json
signer2=signer2.json
signer3=signer3.json
signer1Pubkey=`solana-keygen pubkey $signer1`
signer2Pubkey=`solana-keygen pubkey $signer2`
signer3Pubkey=`solana-keygen pubkey $signer3`
echo ""

# Set up your fee payer
echo "setting up the fee payer account, which is signer1.json keypair by default"
#will test on localnet
solana airdrop 5 $signer1Pubkey
feePayer=$signer1
solana config set --keypair $signer1
echo ""

# create the multisig
echo "creating the mutisig account"
multisigAddress=`spl-token create-multisig 1 $signer1Pubkey $signer2Pubkey $signer3Pubkey | grep multisig | xargs -n 1 | tail -n -1`
echo "multisigAddress: $multisigAddress"
echo ""

# transfer 3 token to shared wallet
amount=3
wSOLTokenAddress=So11111111111111111111111111111111111111112 #NOTE! Unwrap the token and it deletes the associated wSOL address!

# create some wrapped sol using the signer1 address 
echo "wrapping some SOL"
spl-token wrap $amount $signer1
echo "sending wrapped sol to $multisigAddress"
amountActual=`spl-token accounts | grep $wSOLTokenAddress | xargs -n 1 | tail -n -1`
spl-token transfer --fund-recipient $wSOLTokenAddress $amountActual $multisigAddress
echo "check the balance"
spl-token accounts --owner $multisigAddress
echo ""

