# Damn Vulnerable DeFi

## Quick use

1. Put write-ups in `src/<challenge-name>/write-up`
2. Put solutions in `test/<challenge-name>/<ChallengeName>.t.sol`
3. Run a solution:

   `forge test --mp test/<challenge-name>/<ChallengeName>.t.sol`

   > In challenges that restrict the number of transactions, you might need to run the test with the `--isolate` flag.

## Progress

- [x] [unstoppable](src/unstoppable/write-up)
- [x] [naive-receiver](src/naive-receiver/write-up)
- [x] [truster](src/truster/write-up)
- [x] [side-entrance](src/side-entrance/write-up)
- [x] [the-rewarder](src/the-rewarder/write-up)
- [x] [selfie](src/selfie/write-up)
- [] compromised
- [x] [puppet](src/puppet/write-up)
- [x] [puppet-v2](src/puppet-v2/write-up)
- [x] [free-rider](src/free-rider/write-up)
- [] backdoor
- [] climber
- [] wallet-mining
- [] puppet-v3
- [] abi-smuggling
- [] shards
- [] curvy-puppet
- [] withdrawal
