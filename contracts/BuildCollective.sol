pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;
import "./ERC721.sol";
import "./Ownable.sol";
import "./SafeMath.sol";

contract BuildCollective is Ownable {
  using SafeMath for uint256;

  struct User {
    string username;
    uint256 balance;
    bool registered;
  }
  struct Company {
    string name;
    address owner;
    address[] members;
    uint256 balance;
  }

  struct Project {
    uint256 id;
    string name;
    address owner;
    address[] contributors;
    uint256 balance;
    string gitAddress;
    bool createdByUser;
  }

  struct Bounty {
    uint256 id;
    string name;
    string descr;
    uint256 reward;
    address fixedBy;
    address huntedBy;
    uint256 projectId;
    uint8 closed;
  }
  mapping(address => User) private users;
  mapping(address => Company) private companies;
  mapping(address => Project) private projects;
  mapping(address => Bounty) private bounties;

  uint256 cptProjectId = 0;
  uint256 cptBountyId = 0;

  Project[] projectsList;
  Company[] companiesList;
  Bounty[] bountiesList;

  event UserSignedUp(address indexed userAddress, User indexed user);
  event CompanySignedUp(
    address indexed companyAddress,
    Company indexed company
  );
  event ProjectCreated(address indexed projectAddress, Project indexed project);
  event BountyCreated(address indexed bountyAddress, Bounty indexed bounty);

  modifier balancePositif(uint256 _reward, bool _createdbyUser) {
    if (_createdbyUser) {
      require(users[msg.sender].balance.sub(_reward) >= 0);
    } else {
      require(companies[msg.sender].balance.sub(_reward) >= 0);
    }
    _;
  }

  modifier isContributor(uint256 _pid) {
    bool exists = false;
    Project memory _p = projectsList[_pid];

    for (uint256 i = 0; i < _p.contributors.length; i++) {
      if (_p.contributors[i] == msg.sender) {
        exists = true;
      }
    }
    require(exists == false);
    _;
  }

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

  function getCompanies() public view returns (Company[] memory) {
    require(users[msg.sender].registered);
    return companiesList;
  }

  function getBounties() public view returns (Bounty[] memory) {
    require(users[msg.sender].registered);

    return bountiesList;
  }

  function getProjectById(uint256 index) public view returns (Project memory) {
    require(users[msg.sender].registered);
    return projectsList[index];
  }

  function getBountyById(uint256 index) public view returns (Bounty memory) {
    require(users[msg.sender].registered);
    return bountiesList[index];
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
    balancePositif(balance, true)
    returns (Company memory)
  {
    address[] memory members = new address[](1);
    members[0] = msg.sender;
    companies[msg.sender] = Company(name, msg.sender, members, balance);
    companiesList.push(Company(name, msg.sender, members, balance));
    users[msg.sender].balance = users[msg.sender].balance - balance;
    emit CompanySignedUp(msg.sender, companies[msg.sender]);
  }

  ///PROJECTS

  function createProject(
    string memory name,
    uint256 balance,
    string memory gitUrl,
    bool createdByUser
  ) public balancePositif(balance, createdByUser) returns (Project memory) {
    address[] memory contributors = new address[](1);
    contributors[0] = msg.sender;

    projects[msg.sender] = Project(
      cptProjectId,
      name,
      msg.sender,
      contributors,
      balance,
      gitUrl,
      createdByUser
    );
    projectsList.push(
      Project(
        cptProjectId,
        name,
        msg.sender,
        contributors,
        balance,
        gitUrl,
        createdByUser
      )
    );
    cptProjectId++;

    if (createdByUser) {
      users[msg.sender].balance = users[msg.sender].balance - balance;
    } else {
      companies[msg.sender].balance = companies[msg.sender].balance - balance;
    }

    emit ProjectCreated(msg.sender, projects[msg.sender]);
  }

  function addContributorToProject(uint256 idProject)
    public
    isContributor(idProject)
    returns (bool)
  {
    projectsList[idProject].contributors.push(msg.sender);
    return true;
  }

  //BOUNTIES
  function createBounty(
    string memory name,
    string memory descr,
    uint256 reward,
    uint256 idProj
  ) public balancePositif(reward, true) returns (Bounty memory) {
    bounties[msg.sender] = Bounty(
      cptBountyId,
      name,
      descr,
      reward,
      address(0),
      msg.sender,
      idProj,
      0
    );
    bountiesList.push(
      Bounty(
        cptBountyId,
        name,
        descr,
        reward,
        address(0),
        msg.sender,
        idProj,
        0
      )
    );
    cptBountyId++;
    users[msg.sender].balance = users[msg.sender].balance - reward;
    emit BountyCreated(msg.sender, bounties[msg.sender]);
  }

  function hunting(uint256 index) public returns (Bounty memory) {
    require(users[msg.sender].registered);
    bountiesList[index].closed = 1;
    users[msg.sender].balance =
      users[msg.sender].balance +
      bountiesList[index].reward;

    return bountiesList[index];
  }
}
