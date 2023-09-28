import FungibleToken from 0xee82856bf20e2aa6

pub contract BuddyToken: FungibleToken {
    pub var totalSupply: UFix64
    pub let VaultStoragePath: StoragePath
    pub let VaultPublicPath: PublicPath
    pub let ReceiverPublicPath: PublicPath
    pub let AdminStoragePath: StoragePath
    pub event TokensInitialized(initialSupply: UFix64)
    pub event TokensWithdrawn(amount: UFix64, from: Address?)
    pub event TokensDeposited(amount: UFix64, to: Address?)
    pub event TokensMinted(amount: UFix64)
    pub event MinterCreated(allowedAmount: UFix64)

    pub resource Vault: FungibleToken.Provider, FungibleToken.Receiver, FungibleToken.Balance {
        pub var balance: UFix64
        init(balance: UFix64) {
            self.balance = balance
        }
        pub fun withdraw(amount: UFix64): @FungibleToken.Vault {
            self.balance = self.balance - amount
            emit TokensWithdrawn(amount: amount, from: self.owner?.address)
            return <-create Vault(balance: amount)
        }
        pub fun deposit(from: @FungibleToken.Vault) {
            let vault <- from as! @BuddyToken.Vault
            self.balance = self.balance + vault.balance
            emit TokensDeposited(amount: vault.balance, to: self.owner?.address)
            vault.balance = 0.0
            destroy vault
        }
        destroy() {
            if self.balance > 0.0 {
                BuddyToken.totalSupply = BuddyToken.totalSupply - self.balance
            }
        }
    }

    pub fun createEmptyVault(): @Vault {
        return <-create Vault(balance: 0.0)
    }

    pub resource Administrator {
        pub fun createNewMinter(allowedAmount: UFix64): @Minter {
            emit MinterCreated(allowedAmount: allowedAmount)
            return <-create Minter(allowedAmount: allowedAmount)
        }
    }
    pub resource Minter {
        pub var allowedAmount: UFix64
        pub fun mintTokens(amount: UFix64): @BuddyToken.Vault {
            pre {
                amount > 0.0: "Amount minted must be greater than zero"
                amount <= self.allowedAmount: "Amount minted must be less than the allowed amount"
            }
            BuddyToken.totalSupply = BuddyToken.totalSupply + amount
            self.allowedAmount = self.allowedAmount - amount
            emit TokensMinted(amount: amount)
            return <-create Vault(balance: amount)
        }
        init(allowedAmount: UFix64) {
            self.allowedAmount = allowedAmount
        }
    }
    init() {
        self.totalSupply = 1000.0
        self.VaultStoragePath = /storage/BuddyTokenVault
        self.VaultPublicPath = /public/BuddyTokenMetadata
        self.ReceiverPublicPath = /public/BuddyTokenReceiver
        self.AdminStoragePath = /storage/BuddyTokenAdmin
        let vault <- create Vault(balance: self.totalSupply)
        self.account.save(<-vault, to: self.VaultStoragePath)
        self.account.link<&{FungibleToken.Receiver}>(
            self.ReceiverPublicPath,
            target: self.VaultStoragePath
        )
        self.account.link<&BuddyToken.Vault{FungibleToken.Balance}>(
            self.VaultPublicPath,
            target: self.VaultStoragePath
        )
        let admin <- create Administrator()
        self.account.save(<-admin, to: self.AdminStoragePath)
        emit TokensInitialized(initialSupply: self.totalSupply)
    }
}
