// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract UserDetailsContract {
    uint256 public userCount = 0;

    struct UserDetails {
        uint256 id;
        string fuid;
        string name;
        string farmname;
        string email;
        string phone;
        string aadhar;
        string addres;
    }

    mapping(uint256 => UserDetails) public userDetails;

    event UserDetailsCreated(
        uint256 id,
        string fuid,
        string name,
        string farmname,
        string email,
        string phone,
        string aadhar,
        string addres
    );

    event UserDetailsDeleted(uint256 id);

    function createUserDetails(
        string memory _fuid,
        string memory _name,
        string memory _farmname,
        string memory _email,
        string memory _phone,
        string memory _aadhar,
        string memory _addres
    ) public {
        userDetails[userCount] = UserDetails(
            userCount,
            _fuid,
            _name,
            _farmname,
            _email,
            _phone,
            _aadhar,
            _addres
        );
        emit UserDetailsCreated(
            userCount,
            _fuid,
            _name,
            _farmname,
            _email,
            _phone,
            _aadhar,
            _addres
        );
        userCount++;
    }
}
