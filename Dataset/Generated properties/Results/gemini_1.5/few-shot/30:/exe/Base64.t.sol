// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/Base64.sol";
contract Base64Test is Test {
    function testEncodeDecode(bytes memory data, bool fileSafe, bool noPadding) public {
        string memory encoded = Base64.encode(data, fileSafe, noPadding);
        bytes memory decoded = Base64.decode(encoded);
        assertEq(data, decoded);
    }

    function testEncodeDecode(bytes memory data) public {
        string memory encoded = Base64.encode(data);
        bytes memory decoded = Base64.decode(encoded);
        assertEq(data, decoded);
    }

    function testEncodeDecode(bytes memory data, bool fileSafe) public {
        string memory encoded = Base64.encode(data, fileSafe);
        bytes memory decoded = Base64.decode(encoded);
        assertEq(data, decoded);
    }

    function testEncodeDecodeEmpty() public {
        testEncodeDecode("");
    }

    function testEncodeDecodeSingleChar() public {
        testEncodeDecode("A");
    }

    function testEncodeDecodeTwoChars() public {
        testEncodeDecode("AB");
    }

    function testEncodeDecodeThreeChars() public {
        testEncodeDecode("ABC");
    }

    function testEncodeDecodeFourChars() public {
        testEncodeDecode("ABCD");
    }

    function testEncodeDecodeHelloWorld() public {
        testEncodeDecode("Hello world!");
    }

    function testEncodeDecodeFileSafeHelloWorld() public {
        testEncodeDecode("Hello world!", true);
    }

    function testEncodeDecodeNoPaddingHelloWorld() public {
        testEncodeDecode("Hello world!", false, true);
    }

    function testEncodeDecodeFileSafeNoPaddingHelloWorld() public {
        testEncodeDecode("Hello world!", true, true);
    }

    function testEncodeDecodeRFC4648TestVectors() public {
        _testEncodeDecodeRFC4648TestVector("", "");
        _testEncodeDecodeRFC4648TestVector("f", "Zg==");
        _testEncodeDecodeRFC4648TestVector("fo", "Zm8=");
        _testEncodeDecodeRFC4648TestVector("foo", "Zm9v");
        _testEncodeDecodeRFC4648TestVector("foob", "Zm9vYg==");
        _testEncodeDecodeRFC4648TestVector("fooba", "Zm9vYmE=");
        _testEncodeDecodeRFC4648TestVector("foobar", "Zm9vYmFy");
    }

    function testEncodeDecodeRFC4648FileSafeTestVectors() public {
        _testEncodeDecodeRFC4648FileSafeTestVector("", "");
        _testEncodeDecodeRFC4648FileSafeTestVector("f", "Zg==");
        _testEncodeDecodeRFC4648FileSafeTestVector("fo", "Zm8=");
        _testEncodeDecodeRFC4648FileSafeTestVector("foo", "Zm9v");
        _testEncodeDecodeRFC4648FileSafeTestVector("foob", "Zm9vYg==");
        _testEncodeDecodeRFC4648FileSafeTestVector("fooba", "Zm9vYmE=");
        _testEncodeDecodeRFC4648FileSafeTestVector("foobar", "Zm9vYmFy");
    }

    function testEncodeDecodeRFC3501TestVectors() public {
        _testEncodeDecodeRFC3501TestVector("", "");
        _testEncodeDecodeRFC3501TestVector("f", "Zg==");
        _testEncodeDecodeRFC3501TestVector("fo", "Zm8=");
        _testEncodeDecodeRFC3501TestVector("foo", "Zm9v");
        _testEncodeDecodeRFC3501TestVector("foob", "Zm9vYg==");
        _testEncodeDecodeRFC3501TestVector("fooba", "Zm9vYmE=");
        _testEncodeDecodeRFC3501TestVector("foobar", "Zm9vYmFy");
    }

    function _testEncodeDecodeRFC4648TestVector(string memory decoded, string memory encoded)
        internal
    {
        assertEq(Base64.encode(bytes(decoded)), encoded);
        assertEq(string(Base64.decode(encoded)), decoded);
    }

    function _testEncodeDecodeRFC4648FileSafeTestVector(string memory decoded, string memory encoded)
        internal
    {
        assertEq(Base64.encode(bytes(decoded), true), encoded);
        assertEq(string(Base64.decode(encoded)), decoded);
    }

    function _testEncodeDecodeRFC3501TestVector(string memory decoded, string memory encoded)
        internal
    {
        encoded = _replace(encoded, "+", "-");
        encoded = _replace(encoded, "/", ",");
        assertEq(Base64.encode(bytes(decoded), true), encoded);
        assertEq(string(Base64.decode(encoded)), decoded);
    }

    function _replace(string memory subject, string memory search, string memory replacement)
        internal
        pure
        returns (string memory result)
    {
        assembly {
            let subjectLength := mload(subject)
            let searchLength := mload(search)
            let replacementLength := mload(replacement)

            subject := add(subject, 0x20)
            search := add(search, 0x20)
            replacement := add(replacement, 0x20)
            result := add(mload(0x40), 0x20)

            let subjectEnd := add(subject, subjectLength)
            if iszero(gt(searchLength, subjectLength)) {
                let subjectSearchEnd := add(sub(subjectEnd, searchLength), 1)
                let h := 0
                if iszero(lt(searchLength, 0x20)) { h := keccak256(search, searchLength) }
                let m := shl(3, sub(0x20, and(searchLength, 0x1f)))
                let s := mload(search)
                for {} 1 {} {
                    let t := mload(subject)
                    // Whether the first `searchLength % 32` bytes of
                    // `subject` and `search` matches.
                    if iszero(shr(m, xor(t, s))) {
                        if h {
                            if iszero(eq(keccak256(subject, searchLength), h)) {
                                mstore(result, t)
                                result := add(result, 1)
                                subject := add(subject, 1)
                                if iszero(lt(subject, subjectSearchEnd)) { break }
                                continue
                            }
                        }
                        // Copy the `replacement` one word at a time.
                        for { let o := 0 } 1 {} {
                            mstore(add(result, o), mload(add(replacement, o)))
                            o := add(o, 0x20)
                            if iszero(lt(o, replacementLength)) { break }
                        }
                        result := add(result, replacementLength)
                        subject := add(subject, searchLength)
                        if searchLength {
                            if iszero(lt(subject, subjectSearchEnd)) { break }
                            continue
                        }
                    }
                    mstore(result, t)
                    result := add(result, 1)
                    subject := add(subject, 1)
                    if iszero(lt(subject, subjectSearchEnd)) { break }
                }
            }

            let resultRemainder := result
            result := add(mload(0x40), 0x20)
            let k := add(sub(resultRemainder, result), sub(subjectEnd, subject))
            // Copy the rest of the string one word at a time.
            for {} lt(subject, subjectEnd) {} {
                mstore(resultRemainder, mload(subject))
                resultRemainder := add(resultRemainder, 0x20)
                subject := add(subject, 0x20)
            }
            result := sub(result, 0x20)
            let last := add(add(result, 0x20), k) // Zeroize the slot after the string.
            mstore(last, 0)
            mstore(0x40, add(last, 0x20)) // Allocate the memory.
            mstore(result, k) // Store the length.
        }
    }
}