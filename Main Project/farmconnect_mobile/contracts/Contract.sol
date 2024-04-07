// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract UserDetailsContract {
    uint256 public userCount = 0;

    struct UserDetails {
        uint256 id;
        string name;
        string email;
        string phone;
        string aadhar;
        string addres;
        string dob;
        string gender;
    }

    mapping(uint256 => UserDetails) public userDetails;

    event UserDetailsCreated(
        uint256 id,
        string name,
        string email,
        string phone,
        string aadhar,
        string addres,
        string dob,
        string gender
    );

    event UserDetailsDeleted(uint256 id);

    function createUserDetails(
        string memory _name,
        string memory _email,
        string memory _phone,
        string memory _aadhar,
        string memory _addres,
        string memory _dob,
        string memory _gender
    ) public {
        userDetails[userCount] = UserDetails(
            userCount,
            _name,
            _email,
            _phone,
            _aadhar,
            _addres,
            _dob,
            _gender
        );
        emit UserDetailsCreated(
            userCount,
            _name,
            _email,
            _phone,
            _aadhar,
            _addres,
            _dob,
            _gender
        );
        userCount++;
    }
}
