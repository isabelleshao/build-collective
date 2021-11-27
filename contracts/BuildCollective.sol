pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./Ownable.sol";

contract BuildCollective is Ownable {
  struct User {
    string username;
    uint256 balance;
    bool registered;
  }

  // Open an entreprise account, with a name, an owner and some members, possibly with a balance.
  struct Company {
    string name;
    address owner;
    //  address[] members;
    uint256 balance;
  }

  /*Create projects on which we can give money for sponsoring. Each project has a balance, a name and a list of contributors. Each project belongs to a user or an entreprise. The money given to the project can be send to contributors, and contributors only.*/
  struct Project {
    string name;
    address owner;
    address[] contributors;
    uint256 balance;
    string gitAddress;
    //  address[] bounties;
  }

  /*
On a project, you should be able to create bounties. Bounties are bugs with a reward: if you spot a bug and you want to have it fix quickly, open a bounty and put some eth on it. When the fix is pushed, the author will get the eth. He’s a bounty hunter.*/

  struct Bounty {
    string name;
    string descr;
    uint256 reward;
    address fixedBy;
    address huntedBy;
    address project;
    bool closed;
  }

  mapping(address => User) private users;
  mapping(address => Company) private companies;
  mapping(address => Project) private projects;
  mapping(address => Bounty) private bounties;

  mapping(address => address) public projectToOwner;
  mapping(address => address) public bountyToProject;

  mapping(address => Project[]) public ownerToProject;
  mapping(address => Bounty[]) public projectToBounty;

  Project[] projectsList;

  event UserSignedUp(address indexed userAddress, User indexed user);
  event CompanySignedUp(
    address indexed companyAddress,
    Company indexed company
  );
  event ProjectCreated(address indexed projectAddress, Project indexed project);
  event BountyCreated(address indexed bountyAddress, Bounty indexed bounty);

  function user(address userAddress) public view returns (User memory) {
    return users[userAddress];
  }

  function company(address companyAddress)
    public
    view
    returns (Company memory)
  {
    return companies[companyAddress];
  }

  function project(address projectAddress)
    public
    view
    returns (Project memory)
  {
    return projects[projectAddress];
  }

  function bounty(address bountyAddress) public view returns (Bounty memory) {
    return bounties[bountyAddress];
  }

  function getProjects() public view returns (Project[] memory) {
    require(users[msg.sender].registered);

    return projectsList;
  }

  ////USERS
  function signUp(string memory username) public returns (User memory) {
    require(bytes(username).length > 0);
    users[msg.sender] = User(username, 0, true);
    emit UserSignedUp(msg.sender, users[msg.sender]);
  }

  function addBalance(uint256 amount) public returns (bool) {
    require(users[msg.sender].registered);
    users[msg.sender].balance += amount;
    return true;
  }

  //COMPANIES
  function signUpCompany(string memory name, uint256 balance)
    public
    returns (Company memory)
  {
    // address[] memory members = new address[](1);
    // members[0] = msg.sender;
    companies[msg.sender] = Company(name, msg.sender, balance);
    emit CompanySignedUp(msg.sender, companies[msg.sender]);
  }

  ///PROJECTS

  function createProject(
    string memory name,
    uint256 balance,
    string memory gitUrl
  ) public returns (Project memory) {
    address[] memory contributors = new address[](1);
    contributors[0] = msg.sender;

    projects[msg.sender] = Project(
      name,
      msg.sender,
      contributors,
      balance,
      gitUrl
    );
    projectsList.push(Project(name, msg.sender, contributors, balance, gitUrl));
    emit ProjectCreated(msg.sender, projects[msg.sender]);
  }

  /* //BOUNTIES
  function createBounty(
    string memory name,
    string memory descr,
    uint256 reward,
    address project
  ) public returns (Company memory) {
    require(bytes(name).length > 0);
    require(bytes(descr).length > 0);
    require(reward >= 0);

    bounties[msg.sender] = Bounty(
      name,
      descr,
      reward,
      address(0),
      msg.sender,
      project,
      false
    );
    emit BountyCreated(msg.sender, bounties[msg.sender]);
  }*/
}
