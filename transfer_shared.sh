lrawSOLTokenAddress=So11111111111111111111111111111111111111112
#add from create script
multisigAddress=G3QWdT97spsdsaR3TUmNW7y9CXAkR2hQC8sKhS5kGr3G
signer1=signer1.json
signer2=signer2.json
signer3=signer3.json
signer1PubKey=2KFanvonLXY5phqPhG54zivqwTrmv13X1ZDWBCaBy96Q
signer2PubKey=CYpuDSdCn51kZW1rYxsTVFC2s7hfcENjxEtSizSKxvDc
signer3PubKey=H3jJsx4kdRq1oUJUn5r7XrQmtsxKF6Viy3hWoUqSRyiz
wSOLTokenAddress=So11111111111111111111111111111111111111112

# Final recipient of the wrapped SOL (sent from the multisig):
echo "signer1PubKey: $signer1PubKey"
recipient=$signer1PubKey
echo "recipient: $recipient"
solana config set --keypair $signer1
amountActual=1.0
# Trsanfer wrapped SOL using signer 2 signature
echo "commencing multisig transfer:"
spl-token transfer --fund-recipient $wSOLTokenAddress $amountActual $recipient \
--owner $multisigAddress \
--multisig-signer $signer2 \
--fee-payer $signer1 
echo "wrapped sol has been sent."
echo ""

### Unwrap SPL TOKEN
#
# Unwrap part 1: need the associated token address for the recipient wrapped SOL:
echo "displaying the SPL token balance for $signer1"
spl-token accounts # for $signer1 keypair
SPLAccountAddress=`spl-token account-info $wSOLTokenAddress $recipient | grep Address | xargs -n 1 | tail -n -1`

# Unwrap part 2: unwrap the SOL to native SOL:
spl-token unwrap $SPLAccountAddress

echo "displaying final balance in native SOL for ${signer1}, address $recipient"
solana balance $recipient
echo ""