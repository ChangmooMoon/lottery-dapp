const Lottery = artifacts.require("Lottery")

contract('Lottery', function ([deployer, user1, user2]) {
    let lottery;

    beforeEach(async () => {
        console.log('Before each')
        lottery = await Lottery.new()
    })

    it.only('getPot should return uint256 value', async () => {
        let pot = await lottery.getPot();
        assert.equal(pot, 0);
    })

    describe('Bet', function () {
        it('should put the bet to the bet queue with 1 bet', async () => {
            let pot = await lottery.getPot();
            assert.equal(pot, 0)
        })

        it('should fail when the bet money is not 0.005eth', async () => {
            // fail transaction
                
        })
    })
})