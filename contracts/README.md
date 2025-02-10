# 本次教程中使用到的和合约交互的指令
* 编译合约
`forge compile`

* 测试合约
`forge test`

* 测试指定测试合约中过的函数
`forge test --mt ${函数名称} -vvvvv `

* 函数选择器
`forge selectors find`


- 使用 makefile指令完成与合约的交互
`make deploy_lulucoin`: 部署 JunCoin ERC20 代币合约
`make deploy_faucet`: 部署水龙头代币合约
`make mint`: 使用 `Owner` 账户进行 ERC20 代币的铸造
`make approve_faucet`: 使用 `Owner` 账户对 `JUNFaucet` 合约进行授权
`make deposit`: 使用 `Owner` 账户向水龙头合约中进行转账
