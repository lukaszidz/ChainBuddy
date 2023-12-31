import FungibleToken from 0x9a0766d93b6608b7
import BuddyToken from 0x74fd73ac49b42e43

pub fun main(account: Address): UFix64 {
    let vaultRef = getAccount(account)
        .getCapability(/public/BuddyTokenMetadata)
        .borrow<&BuddyToken.Vault{FungibleToken.Balance}>()
        ?? panic("Could not borrow Balance reference to the Vault")

    return vaultRef.balance
}