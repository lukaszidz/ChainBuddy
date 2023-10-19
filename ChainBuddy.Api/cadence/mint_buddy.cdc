import FungibleToken from 0x9a0766d93b6608b7
import BuddyToken from 0xf8d6e0586b0a20c7

transaction(recipient: Address, amount: UFix64) {
    let tokenAdmin: &BuddyToken.Administrator
    let tokenReceiver: &{FungibleToken.Receiver}
    let supplyBefore: UFix64

    prepare(signer: AuthAccount) {
        self.supplyBefore = BuddyToken.totalSupply

        self.tokenAdmin = signer.borrow<&BuddyToken.Administrator>(from: BuddyToken.AdminStoragePath)
            ?? panic("Signer is not the token admin")

        self.tokenReceiver = getAccount(recipient)
            .getCapability(BuddyToken.ReceiverPublicPath)
            .borrow<&{FungibleToken.Receiver}>()
            ?? panic("Unable to borrow receiver reference")
    }

    execute {
        let minter <- self.tokenAdmin.createNewMinter(allowedAmount: amount)
        let mintedVault <- minter.mintTokens(amount: amount)

        self.tokenReceiver.deposit(from: <-mintedVault)

        destroy minter
    }

    post {
        BuddyToken.totalSupply == self.supplyBefore + amount: "The total supply must be increased by the amount"
    }
}