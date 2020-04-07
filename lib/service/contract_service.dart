import 'dart:async';
import 'package:web3dart/web3dart.dart';

typedef TransferEvent = void Function(
    EthereumAddress from, EthereumAddress to, BigInt value);

abstract class IContractService {
  Future<Credentials> getCredentials(String privateKey);

  Future<String> send(String privateKey, 
                      EthereumAddress receiver, 
                      BigInt amount, 
                      {TransferEvent onTransfer, 
                      Function onError});

  Future<String> buy(String privateKey, 
                      BigInt amount, 
                      {TransferEvent onTransfer, 
                      Function onError});

  Future<String> sell(String privateKey, 
                      BigInt amount, 
                      {TransferEvent onTransfer, 
                      Function onError});

  Future<String> sendEth(String privateKey, 
                          EthereumAddress receiver, 
                          BigInt amount);

  Future<BigInt> getTokenBalance(EthereumAddress from);

  Future<BigInt> getBuyPrice();

  Future<BigInt> getSellPrice();

  Future<EtherAmount> getEthBalance(EthereumAddress from);

  Future<void> dispose();

  StreamSubscription listenTransfer(TransferEvent onTransfer);

  Future<EtherAmount> getEthGasPrice();
}

class ContractService implements IContractService {
  ContractService(this.client, this.contract);

  final Web3Client client;
  final DeployedContract contract;

  ContractEvent _transferEvent() => contract.event('Transfer');
  ContractFunction _balanceFunction() => contract.function('balanceOf');
  ContractFunction _sendFunction() => contract.function('transfer');
  ContractFunction _buyFunction() => contract.function('buy');
  ContractFunction _sellFunction() => contract.function('sell');
  ContractFunction _buyPriceFunction() => contract.function('buyPrice');
  ContractFunction _sellPriceFunction() => contract.function('sellPrice');

  Future<Credentials> getCredentials(String privateKey) =>
      client.credentialsFromPrivateKey(privateKey);

  Future<String> send(String privateKey, 
                      EthereumAddress receiver, 
                      BigInt amount, 
                      {TransferEvent onTransfer, 
                      Function onError}) async {
    final credentials = await this.getCredentials(privateKey);
    final from = await credentials.extractAddress();
    final networkId = await client.getNetworkId();

    StreamSubscription event;
    // Work around once sendTransacton doesn't return a Promise containing confirmation / receipt
    if (onTransfer != null) {
      event = listenTransfer((from, to, value) async {
        onTransfer(from, to, value);
        await event.cancel();
      }, take: 1);
    }

    try {
      final transactionId = await client.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: contract,
          function: _sendFunction(),
          gasPrice: EtherAmount.inWei(BigInt.from(1000000000)), // ZOIS: set it in UI
          maxGas: 3000000, // ZOIS: set it in UI
          parameters: [receiver, amount],
          from: from,
        ),
        chainId: networkId,
      );
      print('transact started $transactionId');
      return transactionId;
    } catch (ex) {
      if (onError != null) {
        onError(ex);
      }
      return null;
    }
  }

  Future<String> buy(String privateKey, 
                      BigInt amount, 
                      {TransferEvent onTransfer, 
                      Function onError}) async {
    final credentials = await this.getCredentials(privateKey);
    final from = await credentials.extractAddress();
    final networkId = await client.getNetworkId();

    StreamSubscription event;
    // Work around once sendTransacton doesn't return a Promise containing confirmation / receipt
    if (onTransfer != null) {
      event = listenTransfer((from, to, value) async {
        onTransfer(from, to, value);
        await event.cancel();
      }, take: 1);
    }

    // amount for PBLC = (buyPrice in contract) * amount
    // e.g to buy 1 PBLC we need the amount to be 63.800 * 1.000.000.000
    var buyPrice = await getBuyPrice();
    if (buyPrice == null || buyPrice == BigInt.from(0)) 
      buyPrice = BigInt.from(63800);
    
    var amountForPBLC = buyPrice * amount;

    try {
      final transactionId = await client.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: contract,
          function: _buyFunction(),
          gasPrice: EtherAmount.inWei(BigInt.from(1000000000)), // ZOIS: set it in UI
          maxGas: 3000000, // ZOIS: set it in UI
          parameters: [],
          from: from,
          value: EtherAmount.inWei(amountForPBLC)
        ),
        chainId: networkId,
      );
      print('transact started $transactionId');
      return transactionId;
    } catch (ex) {
      if (onError != null) {
        onError(ex);
      }
      return null;
    }
  }

  Future<String> sell(String privateKey, 
                      BigInt amount, 
                      {TransferEvent onTransfer, 
                      Function onError}) async {
    final credentials = await this.getCredentials(privateKey);
    final from = await credentials.extractAddress();
    final networkId = await client.getNetworkId();

    StreamSubscription event;
    // Work around once sendTransacton doesn't return a Promise containing confirmation / receipt
    if (onTransfer != null) {
      event = listenTransfer((from, to, value) async {
        onTransfer(from, to, value);
        await event.cancel();
      }, take: 1);
    }

    // 0.000063770000000000ETH = 1 token
    // var sellPrice = await getSellPrice();
    // if (sellPrice == null || sellPrice == BigInt.from(0)) 
    //  sellPrice = BigInt.from(63770);
    
    try {
      final transactionId = await client.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: contract,
          function: _sellFunction(),
          gasPrice: EtherAmount.inWei(BigInt.from(1000000000)), // ZOIS: set it in UI
          maxGas: 3000000, // ZOIS: set it in UI
          parameters: [amount],
          from: from
        ),
        chainId: networkId,
      );
      print('transact started $transactionId');
      return transactionId;
    } catch (ex) {
      if (onError != null) {
        onError(ex);
      }
      return null;
    }
  }

  Future<String> sendEth(String privateKey, 
                          EthereumAddress receiver, 
                          BigInt amount) async {
    final credentials = await this.getCredentials(privateKey);
    final networkId = await client.getNetworkId();

    try {
      final transactionId = await client.sendTransaction(
        credentials,
        Transaction(
          to: receiver,
          gasPrice: EtherAmount.inWei(BigInt.from(1000000000)),
          maxGas: 3000000,
          value: EtherAmount.fromUnitAndValue(EtherUnit.wei, amount),
        ),
        chainId: networkId,
      );
      print('transact started $transactionId');
      return transactionId;
    } catch (ex) {
      return null;
    }
  }

  Future<EtherAmount> getEthBalance(EthereumAddress from) async {
    return await client.getBalance(from);
  }

  Future<EtherAmount> getEthGasPrice() async {
    return await client.getGasPrice();
  }

  Future<BigInt> getTokenBalance(EthereumAddress from) async {
    try {
      print(client);
      var response = await client.call(
        contract: contract,
        function: _balanceFunction(),
        params: [from],
      );

      return response.first as BigInt;
    }
    catch (e) {
      print("${e.toString()} \n Couldn't get PBLC balance for address: $from");
      return BigInt.from(0);
    }
  }

  Future<BigInt> getBuyPrice() async {
    try {
      var response = await client.call(
        contract: contract,
        function: _buyPriceFunction(),
        params: [],
      );

      return response.first as BigInt;
    }
    catch (e) {
      print("${e.toString()} \n Couldn't get buyPrice for address: ${contract.address}");
      return BigInt.from(0);
    }
  }

  Future<BigInt> getSellPrice() async {
    try {
      var response = await client.call(
        contract: contract,
        function: _sellPriceFunction(),
        params: [],
      );

      return response.first as BigInt;
    }
    catch (e) {
      print("${e.toString()} \n Couldn't get sellPrice for address: ${contract.address}");
      return BigInt.from(0);
    }
  }

  StreamSubscription listenTransfer(TransferEvent onTransfer, {int take}) {
    var events = client.events(FilterOptions.events(
      contract: contract,
      event: _transferEvent(),
    ));

    if (take != null) {
      events = events.take(take);
    }

    return events.listen((event) {
      final decoded = _transferEvent().decodeResults(event.topics, event.data);

      final from = decoded[0] as EthereumAddress;
      final to = decoded[1] as EthereumAddress;
      final value = decoded[2] as BigInt;

      onTransfer(from, to, value);
    });
  }

  Future<void> dispose() async {
    await client.dispose();
  }
}
