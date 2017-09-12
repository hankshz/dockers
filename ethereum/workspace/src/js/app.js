App = {
    web3Provider: null,

    init: function() {
        App.initWeb3();
        App.initContract();
    },

    initWeb3: function() {
        if ( typeof web3 !== 'undefined' ) {
            App.web3Provider = web3.currentProvider;
        } else {
            alert("Please install MetaMask first");
            //TODO: make web3 work with Truffle in the client side
            //App.web3Provider = new web3.providers.HttpProvider('http://localhost:8445');
        }
        web3 = new Web3(App.web3Provider);
    },

    initContract: function() {
        $.getJSON('Betting.json', function(data) {
            //get the necessary contract artifact file and instnatiate it with truffle-contract.
            var BettingArtifact = data;
            App.contracts.Betting = TruffleContract(BettingArtifact);

            //set the provider for our contract.
            App.contracts.Betting.setProvider(App.web3Provider);

            //reset the bet
            //App.resetBet();
        });
    },
};

$(function() {
    $(window).load(function() {
        App.init();
    });
});
