# PhoneBook
Final project on my live class. (monthly 2 times)

#### road map:

|| source | live |
| ---- | ---- | ---- |
| develop contract | [here](https://github.com/mosi-sol/Solidity101/blob/main/collection-1/01-PhoneBook_ByQuestion.sol) | □ |
| update features | [here](https://github.com/mosi-sol/Solidity101/blob/main/collection-1/02-PhoneBook_WithAnswer.sol) | □ |
| refactor | [interface](https://github.com/mosi-sol/Solidity101/blob/main/collection-1/IPhoneBook.sol) - [phonebook](https://github.com/mosi-sol/Solidity101/blob/main/collection-1/03.PhoneBook_Refactor.sol) | □ |
| deploy | [Demo: BSC testnet](https://testnet.bscscan.com/address/0x97de9a26690dcdc0312f04e3be263c157f6c1fb8) | ■ |
| factory edition | [here](https://github.com/mosi-sol/Solidity101/blob/main/collection-1/05.PhoneBook_Factory.sol) | □ |
| deploy | [Demo: BSC testnet](https://testnet.bscscan.com/address/0xf78a2f557ccff5a993ecd4fc83d02e02c9493802) | ■ |
| unit test | [Example internal test](https://github.com/mosi-sol/Solidity101/blob/main/collection-1/06.UnitTest.sol) - [Foundry external test](https://github.com/mosi-sol/Solidity101/tree/main/collection-1/Foundry%20Test) | □ |
| ui design | [source](https://github.com/mosi-sol/Solidity101/blob/main/collection-1/06.Index-ui.html) - [Demo: ipfs] | □ |
| connect back to front | [here] | □ |
| ux | [here] | □ |
| deploy on ipfs / github-page | [here] | □ |
| final web3 version of phonebook | [here] | □ |
<!-- https://gateway.pinata.cloud/ipfs/QmYyQ6WMTPrpSddhSyefwfGs6xrpD9SpXs1uNTyTboPXgF?_gl=1*1e7re46*_ga*MTE1ODgxNTI0LjE2NzgyNzUzMjI.*_ga_5RMPXG14TE*MTY3ODI3NTMyMi4xLjEuMTY3ODI3NjExMi40NC4wLjA. -->
#### factory:
- factory deploy a phonebook, [here](https://testnet.bscscan.com/address/0xf78a2f557ccff5a993ecd4fc83d02e02c9493802#internaltx)
- then we add new user number
- check [here](https://testnet.bscscan.com/address/0xf98b3e9ea2d1574270e5ca45f1dde53dc4f884de#events)
- where method is `0x36d6da55`
- change last row from `hex` to `text`
- - this is the last number added by using/generating from factory

#### why factory?
- Lower gas costs
- Large quantity output (deploy) at low cost
- Safe, fast & secure

#### using:
- search algorithms [ powerd by hashing, from O(n) to O(1) ]

#### usecase:
- when you need multiple deploying
- can use in platform's or project's as/is whitelist/blacklist, etc...

> just understand the code, than make usecase!

#

**product web3 dApp - from zero to hero**
