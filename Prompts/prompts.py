import json
from langchain.prompts import PromptTemplate
import tiktoken
import os
from langchain_chroma import Chroma
from langchain_core.example_selectors import SemanticSimilarityExampleSelector
from langchain_openai import OpenAIEmbeddings
from langchain_core.documents import Document

examples=  [
    {
      "input": "// SPDX-License-Identifier: MIT\npragma solidity >=0.8.20;\n\nimport '../libraries/FeeMath.sol';\nimport './WildcatMarketBase.sol';\nimport './WildcatMarketConfig.sol';\nimport './WildcatMarketToken.sol';\nimport './WildcatMarketWithdrawals.sol';\n\ncontract WildcatMarket is\n  WildcatMarketBase,\n  WildcatMarketConfig,\n  WildcatMarketToken,\n  WildcatMarketWithdrawals\n{\n  using MathUtils for uint256;\n  using SafeCastLib for uint256;\n  using SafeTransferLib for address;\n\n  /**\n   * @dev Apply pending interest, delinquency fees and protocol fees\n   *      to the state and process the pending withdrawal batch if\n   *      one exists and has expired, then update the market's\n   *      delinquency status.\n   */\n  function updateState() external nonReentrant {\n    MarketState memory state = _getUpdatedState();\n    _writeState(state);\n  }\n\n  /**\n   * @dev Deposit up to `amount` underlying assets and mint market tokens\n   *      for `msg.sender`.\n   *\n   *      The actual deposit amount is limited by the market's maximum deposit\n   *      amount, which is the configured `maxTotalSupply` minus the current\n   *      total supply.\n   *\n   *      Reverts if the market is closed or if the scaled token amount\n   *      that would be minted for the deposit is zero.\n   */\n  function depositUpTo(\n    uint256 amount\n  ) public virtual nonReentrant returns (uint256 /* actualAmount */) {\n    // Get current state\n    MarketState memory state = _getUpdatedState();\n\n    if (state.isClosed) {\n      revert DepositToClosedMarket();\n    }\n\n    // Reduce amount if it would exceed totalSupply\n    amount = MathUtils.min(amount, state.maximumDeposit());\n\n    // Scale the mint amount\n    uint104 scaledAmount = state.scaleAmount(amount).toUint104();\n    if (scaledAmount == 0) revert NullMintAmount();\n\n    // Transfer deposit from caller\n    asset.safeTransferFrom(msg.sender, address(this), amount);\n\n    // Cache account data and revert if not authorized to deposit.\n    Account memory account = _getAccountWithRole(msg.sender, AuthRole.DepositAndWithdraw);\n    account.scaledBalance += scaledAmount;\n    _accounts[msg.sender] = account;\n\n    emit Transfer(address(0), msg.sender, amount);\n    emit Deposit(msg.sender, amount, scaledAmount);\n\n    // Increase supply\n    state.scaledTotalSupply += scaledAmount;\n\n    // Update stored state\n    _writeState(state);\n\n    return amount;\n  }\n\n  /**\n   * @dev Deposit exactly `amount` underlying assets and mint market tokens\n   *      for `msg.sender`.\n   *\n   *     Reverts if the deposit amount would cause the market to exceed the\n   *     configured `maxTotalSupply`.\n   */\n  function deposit(uint256 amount) external virtual {\n    uint256 actualAmount = depositUpTo(amount);\n    if (amount != actualAmount) {\n      revert MaxSupplyExceeded();\n    }\n  }\n\n  /**\n   * @dev Withdraw available protocol fees to the fee recipient.\n   */\n  function collectFees() external nonReentrant {\n    MarketState memory state = _getUpdatedState();\n    if (state.accruedProtocolFees == 0) {\n      revert NullFeeAmount();\n    }\n    uint128 withdrawableFees = state.withdrawableProtocolFees(totalAssets());\n    if (withdrawableFees == 0) {\n      revert InsufficientReservesForFeeWithdrawal();\n    }\n    state.accruedProtocolFees -= withdrawableFees;\n    _writeState(state);\n    asset.safeTransfer(feeRecipient, withdrawableFees);\n    emit FeesCollected(withdrawableFees);\n  }\n\n  /**\n   * @dev Withdraw funds from the market to the borrower.\n   *\n   *      Can only withdraw up to the assets that are not required\n   *      to meet the borrower's collateral obligations.\n   *\n   *      Reverts if the market is closed.\n   */\n  function borrow(uint256 amount) external onlyBorrower nonReentrant {\n    MarketState memory state = _getUpdatedState();\n    if (state.isClosed) {\n      revert BorrowFromClosedMarket();\n    }\n    uint256 borrowable = state.borrowableAssets(totalAssets());\n    if (amount > borrowable) {\n      revert BorrowAmountTooHigh();\n    }\n    _writeState(state);\n    asset.safeTransfer(msg.sender, amount);\n    emit Borrow(amount);\n  }\n\n  /**\n   * @dev Sets the market APR to 0% and marks market as closed.\n   *\n   *      Can not be called if there are any unpaid withdrawal batches.\n   *\n   *      Transfers remaining debts from borrower if market is not fully\n   *      collateralized; otherwise, transfers any assets in excess of\n   *      debts to the borrower.\n   */\n  function closeMarket() external onlyController nonReentrant {\n    MarketState memory state = _getUpdatedState();\n    state.annualInterestBips = 0;\n    state.isClosed = true;\n    state.reserveRatioBips = 0;\n    if (_withdrawalData.unpaidBatches.length() > 0) {\n      revert CloseMarketWithUnpaidWithdrawals();\n    }\n    uint256 currentlyHeld = totalAssets();\n    uint256 totalDebts = state.totalDebts();\n    if (currentlyHeld < totalDebts) {\n      // Transfer remaining debts from borrower\n      asset.safeTransferFrom(borrower, address(this), totalDebts - currentlyHeld);\n    } else if (currentlyHeld > totalDebts) {\n      // Transfer excess assets to borrower\n      asset.safeTransfer(borrower, currentlyHeld - totalDebts);\n    }\n    _writeState(state);\n    emit MarketClosed(block.timestamp);\n  }\n}\n",
      "output": "// SPDX-License-Identifier: MIT\npragma solidity >=0.8.20;\n\nimport '../myfilename/BaseMarketTest.sol';\nimport '../myfilename/interfaces/IMarketEventsAndErrors.sol';\nimport '../myfilename/libraries/MathUtils.sol';\nimport '../myfilename/libraries/SafeCastLib.sol';\nimport '../myfilename/libraries/MarketState.sol';\nimport 'solady/utils/SafeTransferLib.sol';\n\ncontract WildcatMarketTest is BaseMarketTest {\n  using stdStorage for StdStorage;\n  // using WadRayMath for uint256;\n  using MathUtils for int256;\n  using MathUtils for uint256;\n\n  // ===================================================================== //\n  //                             updateState()                             //\n  // ===================================================================== //\n\n  function test_updateState() external {\n    _deposit(alice, 1e18);\n    fastForward(365 days);\n    MarketState memory state = pendingState();\n    updateState(state);\n    market.updateState();\n    assertEq(market.previousState(), state);\n  }\n\n  function test_updateState_NoChange() external {\n    _deposit(alice, 1e18);\n    MarketState memory state = pendingState();\n    bytes32 stateHash = keccak256(abi.encode(state));\n    market.updateState();\n    assertEq(keccak256(abi.encode(market.previousState())), stateHash);\n    assertEq(keccak256(abi.encode(market.currentState())), stateHash);\n  }\n\n  function test_updateState_HasPendingExpiredBatch() external {\n    parameters.annualInterestBips = 3650;\n    setUp();\n    _deposit(alice, 1e18);\n    _requestWithdrawal(alice, 1e18);\n    uint32 expiry = previousState.pendingWithdrawalExpiry;\n    fastForward(1 days);\n    MarketState memory state = pendingState();\n    vm.expectEmit(address(market));\n    emit ScaleFactorUpdated(1.001e27, 1e24, 0, 0);\n    vm.expectEmit(address(market));\n    emit WithdrawalBatchExpired(expiry, 1e18, 1e18, 1e18);\n    vm.expectEmit(address(market));\n    emit WithdrawalBatchClosed(expiry);\n    vm.expectEmit(address(market));\n    emit StateUpdated(1.001e27, false);\n    market.updateState();\n  }\n\n  function test_updateState_HasPendingExpiredBatch_SameBlock() external {\n    parameters.withdrawalBatchDuration = 0;\n    setUpContracts(true);\n    setUp();\n    _deposit(alice, 1e18);\n    _requestWithdrawal(alice, 1e18);\n    MarketState memory state = pendingState();\n    vm.expectEmit(address(market));\n    emit WithdrawalBatchExpired(block.timestamp, 1e18, 1e18, 1e18);\n    vm.expectEmit(address(market));\n    emit WithdrawalBatchClosed(block.timestamp);\n    vm.expectEmit(address(market));\n    emit StateUpdated(1e27, false);\n    market.updateState();\n  }\n\n  // ===================================================================== //\n  //                         depositUpTo(uint256)                          //\n  // ===================================================================== //\n\n  function test_depositUpTo() external asAccount(alice) {\n    _deposit(alice, 50_000e18);\n    assertEq(market.totalSupply(), 50_000e18);\n    assertEq(market.balanceOf(alice), 50_000e18);\n  }\n\n  function test_depositUpTo(uint256 amount) external asAccount(alice) {\n    amount = bound(amount, 1, DefaultMaximumSupply);\n    market.depositUpTo(amount);\n  }\n\n  function test_depositUpTo_ApprovedOnController() public asAccount(bob) {\n    _authorizeLender(bob);\n    vm.expectEmit(address(market));\n    emit AuthorizationStatusUpdated(bob, AuthRole.DepositAndWithdraw);\n    market.depositUpTo(1e18);\n    assertEq(uint(market.getAccountRole(bob)), uint(AuthRole.DepositAndWithdraw));\n  }\n\n  function test_depositUpTo_NullMintAmount() external asAccount(alice) {\n    vm.expectRevert(IMarketEventsAndErrors.NullMintAmount.selector);\n    market.depositUpTo(0);\n  }\n\n  function testDepositUpTo_MaxSupplyExceeded() public asAccount(bob) {\n    _authorizeLender(bob);\n    asset.transfer(address(1), type(uint128).max);\n    asset.mint(bob, DefaultMaximumSupply);\n    asset.approve(address(market), DefaultMaximumSupply);\n    market.depositUpTo(DefaultMaximumSupply - 1);\n    market.depositUpTo(2);\n    assertEq(market.balanceOf(bob), DefaultMaximumSupply);\n    assertEq(asset.balanceOf(bob), 0);\n  }\n\n  function testDepositUpTo_NotApprovedLender() public asAccount(bob) {\n    asset.mint(bob, 1e18);\n    asset.approve(address(market), 1e18);\n    vm.expectRevert(IMarketEventsAndErrors.NotApprovedLender.selector);\n    market.depositUpTo(1e18);\n  }\n\n  function testDepositUpTo_TransferFail() public asAccount(alice) {\n    asset.approve(address(market), 0);\n    vm.expectRevert(SafeTransferLib.TransferFromFailed.selector);\n    market.depositUpTo(50_000e18);\n  }\n\n  // ===================================================================== //\n  //                           deposit(uint256)                            //\n  // ===================================================================== //\n\n  function test_deposit(uint256 amount) external asAccount(alice) {\n    amount = bound(amount, 1, DefaultMaximumSupply);\n    market.deposit(amount);\n  }\n\n  function testDeposit_NotApprovedLender() public asAccount(bob) {\n    vm.expectRevert(IMarketEventsAndErrors.NotApprovedLender.selector);\n    market.deposit(1e18);\n  }\n\n  function testDeposit_MaxSupplyExceeded() public asAccount(alice) {\n    market.deposit(DefaultMaximumSupply - 1);\n    vm.expectRevert(IMarketEventsAndErrors.MaxSupplyExceeded.selector);\n    market.deposit(2);\n  }\n\n  // ===================================================================== //\n  //                             collectFees()                             //\n  // ===================================================================== //\n\n  function test_collectFees_NoFeesAccrued() external {\n    vm.expectRevert(IMarketEventsAndErrors.NullFeeAmount.selector);\n    market.collectFees();\n  }\n\n  function test_collectFees() external {\n    _deposit(alice, 1e18);\n    fastForward(365 days);\n    vm.expectEmit(address(asset));\n    emit Transfer(address(market), feeRecipient, 1e16);\n    vm.expectEmit(address(market));\n    emit FeesCollected(1e16);\n    market.collectFees();\n  }\n\n  function test_collectFees_InsufficientReservesForFeeWithdrawal() external {\n    _deposit(alice, 1e18);\n    fastForward(1);\n    asset.burn(address(market), 1e18);\n    vm.expectRevert(IMarketEventsAndErrors.InsufficientReservesForFeeWithdrawal.selector);\n    market.collectFees();\n  }\n\n  // ===================================================================== //\n  //                            borrow(uint256)                            //\n  // ===================================================================== //\n\n  function test_borrow(uint256 amount) external {\n    uint256 availableCollateral = market.borrowableAssets();\n    assertEq(availableCollateral, 0, 'borrowable should be 0');\n\n    vm.prank(alice);\n    market.depositUpTo(50_000e18);\n    assertEq(market.borrowableAssets(), 40_000e18, 'borrowable should be 40k');\n    vm.prank(borrower);\n    market.borrow(40_000e18);\n    assertEq(asset.balanceOf(borrower), 40_000e18);\n  }\n\n  function test_borrow_BorrowAmountTooHigh() external {\n    vm.prank(alice);\n    market.depositUpTo(50_000e18);\n\n    vm.startPrank(borrower);\n    vm.expectRevert(IMarketEventsAndErrors.BorrowAmountTooHigh.selector);\n    market.borrow(40_000e18 + 1);\n  }\n\n  // ===================================================================== //\n  //                             closeMarket()                              //\n  // ===================================================================== //\n\n  function test_closeMarket_TransferRemainingDebt() external asAccount(address(controller)) {\n    // Borrow 80% of deposits then request withdrawal of 100% of deposits\n    _depositBorrowWithdraw(alice, 1e18, 8e17, 1e18);\n    startPrank(borrower);\n    asset.approve(address(market), 8e17);\n    stopPrank();\n    vm.expectEmit(address(asset));\n    emit Transfer(borrower, address(market), 8e17);\n    market.closeMarket();\n  }\n\n  function test_closeMarket_TransferExcessAssets() external asAccount(address(controller)) {\n    // Borrow 80% of deposits then request withdrawal of 100% of deposits\n    _depositBorrowWithdraw(alice, 1e18, 8e17, 1e18);\n    asset.mint(address(market), 1e18);\n    vm.expectEmit(address(asset));\n    emit Transfer(address(market), borrower, 2e17);\n    market.closeMarket();\n  }\n\n  function test_closeMarket_FailTransferRemainingDebt() external asAccount(address(controller)) {\n    // Borrow 80% of deposits then request withdrawal of 100% of deposits\n    _depositBorrowWithdraw(alice, 1e18, 8e17, 1e18);\n    vm.expectRevert(SafeTransferLib.TransferFromFailed.selector);\n    market.closeMarket();\n  }\n\n  function test_closeMarket_NotController() external {\n    vm.expectRevert(IMarketEventsAndErrors.NotController.selector);\n    market.closeMarket();\n  }\n\n  function test_closeMarket_CloseMarketWithUnpaidWithdrawals()\n    external\n    asAccount(address(controller))\n  {\n    _depositBorrowWithdraw(alice, 1e18, 8e17, 1e18);\n    fastForward(parameters.withdrawalBatchDuration);\n    market.updateState();\n    uint32[] memory unpaidBatches = market.getUnpaidBatchExpiries();\n    assertEq(unpaidBatches.length, 1);\n    vm.expectRevert(IMarketEventsAndErrors.CloseMarketWithUnpaidWithdrawals.selector);\n    market.closeMarket();\n  }\n}\n"
    }
 ]

vminterface="""
interface Vm:
"""

def zeroShot(input_sc,pragma,contractname,filename,references,custom_invariant,modelname):
    opencurly = "{"
    closedcurly = "}"
    path = os.path.join("../", filename)
    path = path.replace("//", "/")
    test_contract_format = (f"// SPDX-License-Identifier: UNLICENSED\n"
                            f"pragma solidity {pragma};\n"
                            f"pragma abicoder v2;\n"
                            f'import {"{Test, console2}"} from "forge-std/Test.sol";\n'
                            f'import "{path + "/" + contractname + ".sol"}";\n'
                            f"contract {contractname}Test is Test {opencurly}\n"
                            f"// all the foundry test function and fuzz invariants\n"
                            f"{closedcurly}\n"
                            )
    zeroShotPrompt1 = PromptTemplate.from_template(
        template="Write foundry test smart contract code in solidity, containing all the possible test properties. Given input contract:\n {input_contract} \n{reference}\nTest Contract Format:\n{testformat}"
    )

    zeroShotPrompt2 = PromptTemplate.from_template(
        template="You are the world's best AI smart contract auditor. Write foundry test smart contract code in solidity, for all the possible test properties. Given input contract:\n {input_contract} \n{reference}\nTest Contract Format:\n{testformat}"
    )

    zeroShotPrompt3 = PromptTemplate.from_template(
        template="""
        I have given you a smart contract. You are instructed to write a foundry test contract for given contract.
        The test contract should cover all the edge cases that can maximize the probability of finding vulnerabilities.
        You will only give me code as output.\n
        Given input contract:\n {input_contract} \n{reference}\nTest Contract Format:\n{testformat}
        """
    )
    zeroShotPrompt1 = zeroShotPrompt1.format(input_contract=input_sc,reference=references,testformat=test_contract_format)
    zeroShotPrompt2 = zeroShotPrompt2.format(input_contract=input_sc,reference=references,testformat=test_contract_format)
    zeroShotPrompt3 = zeroShotPrompt3.format(input_contract=input_sc,reference=references,testformat=test_contract_format)

    return zeroShotPrompt1, zeroShotPrompt2, zeroShotPrompt3


def solady_fewShot(input_sc,pragma,contractname,filename,references,custom_invariant,modelname):

    if not os.path.exists("./chroma_db/chroma.sqlite3"):
        examplespath = os.path.join(os.getcwd(), "Prompts/solady_examples.json")
        examples = None
        with open(examplespath, "r") as json_file:
            examples = json.load(json_file)
        docexamples = []
        for example in examples:
            docexamples.append(Document(page_content=example["input"], metadata=example))
        db2 = Chroma.from_documents(docexamples, OpenAIEmbeddings(), persist_directory="./chroma_db")
        print("Database created")
    db3 = Chroma(persist_directory="./chroma_db", embedding_function=OpenAIEmbeddings())
    docs = db3.similarity_search(input_sc,3)
    selected_examples = []
    for doc in docs:
        if doc.metadata["contractname"]!=contractname+".sol":
            selected_examples.append(doc.metadata)

    # example_selector = SemanticSimilarityExampleSelector.from_examples(
    #     # This is the list of examples available to select from.
    #     examples,
    #     # This is the embedding class used to produce embeddings which are used to measure semantic similarity.
    #     OpenAIEmbeddings(),
    #     # This is the VectorStore class that is used to store the embeddings and do a similarity search over.
    #     Chroma(persist_directory="./chromadb",embedding_function=OpenAIEmbeddings()),
    #     # This is the number of examples to produce.
    #     k=2,
    # )

    # selected_examples = example_selector.select_examples({"input": input_sc})



    # STEP2: Create few shot prompt
    prompt = "Here are few-shot examples of pair of contract with their corresponding foundry test contract to test solidity contracts:\n"
    encoding = tiktoken.encoding_for_model("gpt-3.5-turbo")
    examplecount=0
    for i, example in enumerate(selected_examples):
        if examplecount<3:
            for k, v in example.items():
                if k!="contractname":
                    examplecount+=1
                    prompt = prompt +"\n"+ k + "\n" + v + "\n\n"


    opencurly="{"
    closedcurly="}"
    path=os.path.join("../",filename)
    path=path.replace("//","/")
    test_contract_format=(f"// SPDX-License-Identifier: UNLICENSED\n"
                          f"pragma solidity {pragma};\n" 
                          f"pragma abicoder v2;\n"
                          f'import {"{Test, console2}"} from "forge-std/Test.sol";\n'
                          f'import "{ path+"/" +contractname+".sol" }";\n'
                          f"contract {contractname}Test is Test {opencurly}\n"
                          f"// all the foundry test function and fuzz invariants\n"
                          f"{closedcurly}\n"
                          )
    if references:
        references="Here are the references of the input smart contract:\n"+references
    prompt=prompt+"Your output should only be the code. Your task is to write the foundry test contract for the given input smart contract:\n" + input_sc + "\n"+references+"\nHere is the template of Output test contract:\n"+test_contract_format
    token_thresh=8000 if modelname=="gpt-3.5"  else 280000 if modelname=="gemini-1.0" else 1000000 if modelname=="gemini-1.5" else 120000 if modelname=="gpt-4" else 10000

    token_count = len(encoding.encode(prompt))
    while token_count > token_thresh:
        prompt = prompt[1000:]
        # prompt = prompt[:-1000]
        token_count = len(encoding.encode(prompt))
    print(prompt)
    print(token_count)
    # print(selected_examples)
    # print("Selected Examples :",len(selected_examples))

    return prompt,prompt

def promptchain_1(smartcontract,references):
    prompt=PromptTemplate.from_template(
        template="""Your task is to list down and explain all the functionalities of the given smart contract each in detail.\nHere is the input smart contract:\n{smartcontract}\n{referencecontracts}"""
    )
    if references:
        references="Here are the references of the input smart contract:\n"+references
    prompt_text=prompt.format(smartcontract=smartcontract,referencecontracts=references)
    return prompt_text

def promptchain_2(smartcontract,references,details):
    prompt=PromptTemplate.from_template(
        template="""Your task is to list all the test invariants for a foundry test contract that can be derived from the given smart contract. Each invariant should cover specific edge cases.\nMake sure to write test invariants for all the functionalities of given contract.\nHere is the input smart contract:\n{smartcontract}\n{referencecontracts}\nExplaination of input smart contract:{sc_details}"""
    )
    if references:
        references="Here are the references of the input smart contract:\n"+references
    prompt_text=prompt.format(smartcontract=smartcontract,referencecontracts=references,sc_details=details)
    return prompt_text

def promptchain_3(input_sc,pragma,contractname,filename,references,custom_invariant,modelname,testprops):
    prompt=PromptTemplate.from_template(
        template="""You are instructed to write a foundry test contract for given contract based on the provided test invariants list.
        You will only give me code as output and your code should be complete with full implementation of test invariants.\nHere is the input smart contract:\n{smartcontract}\n{referencecontracts}\nHere is the output test contract format:\n{testformat}\nThe following is the list of the test properties that you have to write for the given contract: \n{testprops_list}"""
    )
    if references:
        references="Here are the references of the input smart contract:\n"+references
    opencurly="{"
    closedcurly="}"
    path=os.path.join("../",filename)
    path=path.replace("//","/")
    test_contract_format=(f"// SPDX-License-Identifier: UNLICENSED\n"
                          f"pragma solidity {pragma};\n" 
                          f"pragma abicoder v2;\n"
                          f'import {"{Test, console2}"} from "forge-std/Test.sol";\n'
                          f'import "{ path+"/" +contractname+".sol" }";\n'
                          f"contract {contractname}Test is Test {opencurly}\n"
                          f"// all the foundry test function and fuzz invariants\n"
                          f"{closedcurly}\n"
                          )
    prompt_text=prompt.format(smartcontract=input_sc,testformat=test_contract_format,referencecontracts=references,testprops_list=testprops)
    return prompt_text




def fewShot(input_sc,pragma,contractname,filename,references,custom_invariant,modelname,invariantlist,functionalties):
    # STEP1: Read the examples from JSON file
    examplespath=os.path.join(os.getcwd(),"Prompts/examples.json")
    with open(examplespath, "r") as json_file:
        examples = json.load(json_file)

    # STEP2: Create few shot prompt
    prompt = "Here are some fewshot examples:\n"
    encoding = tiktoken.encoding_for_model("gpt-3.5-turbo")
    for i,example in enumerate(examples):
        if i<3:
            for k, v in example.items():
                v=v.replace("myfilename",filename)
                prompt = prompt + k + "\n" + v + "\n\n"

    opencurly="{"
    closedcurly="}"
    path=os.path.join("../",filename)
    path=path.replace("//","/")
    test_contract_format=(f"// SPDX-License-Identifier: UNLICENSED\n"
                          f"pragma solidity {pragma};\n" 
                          f"pragma abicoder v2;\n"
                          f'import {"{Test, console2}"} from "forge-std/Test.sol";\n'
                          f'import "{ path+"/" +contractname+".sol" }";\n'
                          f"contract {contractname}Test is Test {opencurly}\n"
                          f"// all the foundry test function and fuzz invariants\n"
                          f"{closedcurly}\n"
                          )
    if references:
        references="Here are the references of the input smart contract:\n"+references
    instr="You are the world's best smart contract auditor.\n I have also given you the description of the test invariants. \nI want to do property based testing.\nYour task is to write foundry test contract for the given input contract. Write proper preconditions in the invariants also write proper view specifiers. You have to provide the proper implementation of the contract do not add comments. Do not use any internal or private function of the input smart contract.\n"

    addressliterals="""
    For address literals you have to keep in mind the following things.
    Address Literals
    Hexadecimal literals that pass the address checksum test, for example 0xdCad3a6d3569DF655070DEd06cb7A1b2Ccd1D3AF are of address type. Hexadecimal literals that are between 39 and 41 digits long and do not pass the checksum test produce an error. You can prepend (for integer types) or append (for bytesNN types) zeros to remove the error.
    Note
    The mixed-case address checksum format is defined in EIP-55.
    """
    if functionalties:
        functionalties="Here are the functionalities of the input smart contract:\n"+functionalties
    instr+="You are the world's best smart contract auditor.\nHere is the list of test invariants for the given smart contract. Your task is to write foundry test contract against these given invariants with full implementation and also add more test function for proper testing. Your output should be a contract should not contain any error. Also keep in mind that private functions are not inherited.\nTest invariant List:\n"+invariantlist+"\n"
    prompt1 ="**"+instr+"**\n"+ "Output Testcontract format:\n"+test_contract_format+ "input Contract:\n" + input_sc +references+functionalties+"\n"
    print("#####################################################################################################")
    print(prompt1)
    print("################################################################################################################")
    return prompt1,prompt1

    instruction = (
        """
    Instructions:
        You are regarded as the premier smart contract auditor globally.
        I have given you a smart contract. First you have to think 3 times about the edge cases and then write foundry test contract for it.
        You have to generate atleast 2000 tokens for the test contract.
        Do write whole code instead of explaining functionality in the comments also add asserts statements by yourself.
        Generate invariants as much you can because we want rigorous testing.
        Ensure that the test contract comprehensively covers all conceivable edge cases, thereby maximizing the probability of identifying vulnerabilities.
        Don't refer any function which is not the member of input smart contract.
        Your output should only code of the test contract file with out any comment implement proper functionality of test contract.
        Don't refer any function which is not the member of input smart contract.
        Do write maximum number of test invariant in the test contract to ensure its security.
        Use proper assert statements.
        Don't refer any function which is not the member of input smart contract.
        Adhere strictly to the following guidelines:
            Write the appropriate mutability for each test function.
            Write test for libraries is different from testing contracts.
            Do not use these type of things using Somelib for address;
            Provide the complete definition of each test function; refrain from omitting code by relying solely on comments to convey functionality. Include proper assert statements.
            Use proper number of arguments during a function call as mentioned in the definition of that function.
            if an input contract have some private or internal functions so don't use them in the test contract.
            Don't use any function which is not the member of input contract.
            Don't refer any function which is not the member of input smart contract.
            Write proper address where needed instead of writing generic placeholders.
            You are strictly not allowed to use any function which is not present in the input contract.
            You are not allowed to use any private and internal function of the input contract.
            There is no simple assert statement with 2 arguments like assert(condition,"message") instead you can use  assertTrue(bool condition) external pure; assertTrue(bool condition, string calldata error) external pure; or any asserts provided in the following.
        Here are some common mistakes which you are not expected to make:
            Your are not allowed to use these statements like  'using SomeLibrary for address'.
            Error: 
            Initial value for constant variable has to be compile-time constant. like address constant from = address(this);
            Error (9582): Member "safeTransferETH" not found or not visible after argument-dependent lookup in address payable.
    """
                   +custom_invariant+
    "The following are some common the functions in foundry that are used in test contracts:"+(vminterface))

    prompt2 = instruction + prompt1 +prompt
    documentation=""
    with open(os.path.join(os.getcwd(),"Prompts/documentation.txt"), "r") as textfile:
        documentation = textfile.read()
        if documentation:
            documentation="\nHere is the foundry documentation to write good foundry test contract :" +documentation
    prompt2 = prompt2 +documentation
    token_thresh=6000 if modelname=="gpt-3.5" else 1000000 if modelname=="gemini" else 120000 if modelname=="gpt-4" else 10000

    token_count = len(encoding.encode(prompt2))
    while token_count > token_thresh:
        prompt2 = prompt2[:-1000]
        token_count = len(encoding.encode(prompt2))
    print(prompt2)
    print(token_count)
    return prompt, prompt2


def soundnessPrompt(invariants):
    # STEP1: Read the examples from JSON file
    with open("Promptsold/examples_soundness.json", "r") as json_file:
        examples = json.load(json_file)
    soundPrompt = """
        As a professional Smart Contract Auditor at Google, your task is to review and address any soundness issues in the provided Solidity code.

        Instructions for Soundness Evaluation, please follow these steps:

        Pre-Conditions Verification:
           - Check for every necessary pre-condition before the assertions. Ensure that all required if-else pre-conditions are present.
           - If any necessary if-else condition is missing, please add it.

        Error Identification and Fixing:
           - Provide a list of identified soundness issues along with the corresponding fixes.
             - Example: "Fix no.X: Added `require(x > 0);` to ensure x is greater than zero."

        Reasoning for Identified Errors:
           - For each identified error, provide a brief explanation of why it is important to address it.
             - Example: "Reason no.X: Checks if either x or y is zero. If true, it asserts that z (the result) is zero."

        Code Soundness Evaluation:
           - Evaluate the soundness of the code and provide a percentage score indicating the level of improvement.

        Here are some examples of sound and unsound properties\n
        """

    soundPrompt = """
    As a professional Smart Contract Auditor at Google, Your task is to improve the soundness of the test contract.
    Your output should be updated code.
    Instructions for Soundness Evaluation, please follow these steps:
    Pre-Conditions Verification:
       - Check for every necessary pre-condition before the assertions. Ensure that all required if-else pre-conditions are present.
       - If any necessary if-else condition is missing, please add it.
    Here are some examples of sound and unsound properties\n
    """

    for example in examples:
        for k, v in example.items():
            soundPrompt = soundPrompt + k + "\n" + v + "\n"

    soundPrompt = soundPrompt + "Improve soundness of the following Smart contract:\n" + invariants

    return soundPrompt


def strengthPrompt(input_sc, output_sc,references):
    stPrompt = PromptTemplate.from_template(
        template="""
            Here is my test smart contract {output_contract},\nReferences smart contract for input smart contract: {reference}\n and here is my input smart contract: \n{input_contract}.
            Please make sure the test smart contract has all the possible fuzz properties and the test contract covers all the edge cases and possible vulnerabilities.
            Your output only will be a test contract code with all test properties in it.
            And here are some common functions in foundry that are used in test contracts:
        {interface}""",
        partial_variables={"reference":references,"interface": vminterface}
    )

    stPrompt = stPrompt.format(input_contract=input_sc, output_contract=output_sc)
    return stPrompt


def compiling_agent_prompt(code, tstfile,references):
    p1 = (
        f"You are the world's best solidity coding error resolver.\n"
        f"Given input and references contract is only for reference you are not allowed to edit it. "
        f"Using this given contract the foundry test file is created by a large language model so it may contain errors in it and your task is to make only the test contract executable by removing the errors from it.\n"
        f"You can use the tool to compile the test contract and then you will resolve all the errors until all the errors are not resolved.\n"
        f"You are allowed to modify the Test contract. like If you found something invalid in it you can remove it.\n"
        f"You can use the tool to find the error in the test contract and then you will resolve all the errors until all the errors are not resolved.\n"
        # f"This smart contract will be used in the foundry tool for testing. You can also add test function in it."
        f"Make this foundry test contract executable by preserving its test logic."
        # f"You wrote this test contract and now you task is to resolve all the errors it have."
        # f"Don't remove imports statement from the test contract."
        f"Your output should be an executable test contract."
        # f"Your output for json should not be contain the json word like it should not be like this  ```json .... ``` it shold be like thi"


    )
    documentation=""
    with open(os.path.join(os.getcwd(),"../Prompts/documentation.txt"), "r") as textfile:
        documentation = textfile.read()
    p1=(f"Your task is to improve and make the test contract executable by removing the errors from it. Input contract is only for your reference from which this test contract is created."
        f"Remove the errors untill all the errors are not resolved and improve the test contract by adding good properties in it. Strictly give me the executable contract as output. If you think there are missing test invariants then you can add them.\n")
    p1="I have created a test contract for the given input contract. My test contract have many compilation errors and it is not good so your task is to replace this test contract with another effective and executable test contract for the given input contract. You can import contracts from the ```../src/```  folder."
    template = PromptTemplate.from_template(
        template="Prompt: {prompt}"
                 "Test Contract:\n```{testfile}```"
                 "References for input contract:\n```{references}```"
                 "Input contract:\n```{inputfile}```"
                "Foundry Documentation:\n```{documentation}```",
        partial_variables={"inputfile": code, "testfile": tstfile, "prompt": p1,"references":references,"documentation":documentation}
    )

    return template



def severityScore(testContract):
    stPrompt = PromptTemplate.from_template(
        template="""
            Give me the severity score of vulnerabilities and edge cases covered by fuzz properties {tContract}.
        """
    )

    stPrompt = stPrompt.format(tContract=testContract)
    return stPrompt

def __init__():
    pass
