pragma solidity ^0.6.2;

contract Bank {
                            // 0 - guest (not exists)
    struct Person {         // 1 - custumer
        address adr;        // 2 - seller
        string login;       // 3 - shop
        string FIO;
        uint balance;       // 4 - dialer
        uint role;          // 5 - admin
        string city;        // 6 - bank
        address shop;
    }                       

    struct Review {
        address from;
        address to;
        string content;
    }

    struct Comment {
        Review from;
        string content;
        uint likes;
        uint dislikes;
    }

    mapping (address => Person) persons;
    
    modifier onlyAdmin {
        require(persons[msg.sender].role == 5);
        _;
    }

    Review[] reviews;

    address[] admins;
    address[] sellers;

    address[] requests;

    address nullValue = 0x0000000000000000000000000000000000000000;

    //guest

    function register(string memory _login, string memory _FIO) public payable {
        require(persons[msg.sender].role == 0, "Account already exist");
        persons[msg.sender] = Person(msg.sender, _login, _FIO, 0, 1, '', nullValue);
    }

    //Seller 

    function requestToCustomer() public payable {
        requests.push(msg.sender);
    }

    //admin

    function upToAdmin(address _adr) onlyAdmin public payable {
        Person memory p = persons[_adr];
        p.role = 5;
        admins.push(_adr);
    }

    function upToSeller(address _adr, string memory _city, address _shop) onlyAdmin public payable {
        Person memory p = persons[_adr];
        require(p.role != 2, "He is already seller!");
        p.role = 2;
        p.city = _city;
        p.shop = _shop;
    }

    function downToCustomer(address _adr) onlyAdmin public payable {
        Person memory p = persons[_adr];
        require(p.role == 2, "He isn't seller!");
        p.role = 1;
        p.city = '';
        p.shop = nullValue;
    }

    function stayCustomer() onlyAdmin public payable {
        downToCustomer(msg.sender);
    }

    function createShop(address _adr, string memory _city) onlyAdmin public payable {
        Person memory p = persons[_adr];
        require(p.role != 3, "He is already shop!");
        p.role = 3;
        p.city = _city;
    }

    function removeShop(address _adr) onlyAdmin public payable{
        Person memory p = persons[_adr];
        require(p.role == 3, "He isn't shop!");
        p.role = 1;
        p.city = '';
    }

    //info

    function showLogin() public view returns (string memory) {
        return persons[msg.sender].login;
    }

    function showFIO() public view returns (string memory) {
        return persons[msg.sender].FIO;
    }
    
    function showBalance() public view returns (uint) {
        return persons[msg.sender].balance;
    }

    function showRole() public view returns (string memory) {
        Person memory p = persons[msg.sender];
        string memory role = "Guest";

        if (p.role == 1) {
            return "Customer";
        } else if (p.role == 2) {
            return "Seller";
        } else if (p.role == 3) {
            return "Shop";
        } else if (p.role == 4) {
            return "Dialer";
        } else if (p.role == 5) {
            return "Admin";
        } else if (p.role == 6) {
            return "Bank";
        }

        return role;
    }

    function showRequests() onlyAdmin public view returns (address[] memory) {
        return requests;
    }

    function showAdmins() onlyAdmin public view returns (address[] memory) {
        return admins;
    }

    function showSellers() onlyAdmin public view returns (address[] memory) {
        return sellers;
    }

}
