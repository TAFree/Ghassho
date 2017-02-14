<?php
/**
 * An adapter is triggered by judge daemon to execute specific judge script for each submission.
 *
 * @authur Yu Tzu Wu <abby8050@gmail.com>
 */

ini_set('display_errors', '1');
ERROR_REPORTING(E_ALL);

interface IConnectInfo {

	const HOST = '45.32.107.147';
	const UNAME = 'ghassho';
	const PW = 'ghasshodb';
	const DBNAME = 'TAFreeDev';

	public static function doConnect();
}

interface ILocalInfo {
    const DIR = '.script';
}

class JudgeAdapter {

	private $student_account;
	private $item;
	private $subitem;
	private $id;
	private $signature;
	private $judgescript;
	private $content;
	private $cmd;
	private $ext;

	private $hookup;

	public static function __construct () {

		try {
	
            // Set unique signature for this process on judger
            $this->signature = uniqid(time(), true) . '(' . gethostname() . ')';
            
            // Connect to MySQL database TAFreeDB
			$this->hookup = UniversalConnect::doConnect();						

            // Sign up submission list and query student_account, item, subitem, id
			$stmt_sub = $this->hookup->prepare('UPDATE process SET judger=\'' . $this->signature. '\' WHERE judger IS NULL ORDER BY id LIMIT 1;SELECT student_account, item, subitem, id FROM process WHERE judger=\'' . $this->signature . '\';');
			$stmt_sub->execute();
			$row_sub = $stmt_sub->fetch(\PDO::FETCH_ASSOC);
			$this->student_account = $row_sub['student_account'];
			$this->item = $row_sub['item'];
			$this->subitem = $row_sub['subitem'];
			$this->id = $row_sub['row'];
			
			// Query judgescript and content
			$stmt_jud = $this->hookup->prepare('SELECT judgescript, content FROM ' . $this->item . ' WHERE subitem=\'' . $this->subitem . '\'');
			$stmt_jud->execute();
			$row_jud = $stmt_jud->fetch(\PDO::FETCH_ASSOC);
            $this->judgescript = $row_jud['judgescript'];
			$this->content = $row_jud['content'];
			echo $this->judgescript;
			echo $this->content;
			
			// Query command
			$this->ext = substr($this->judgescript, strrpos($this->judgescript, '.') + 1);
			$stmt_cmd = $this->hookup->prepare('SELECT cmd FROM support WHERE ext=\'' . $this->ext . '\'');
			$stmt_cmd->execute();
			$row_cmd = $stmt_cmd->fetch(\PDO::FETCH_ASSOC);
			$this->cmd = $row_cmd['cmd'];
			echo $this->cmd;

		}
		catch (\PDOException $e) {
			echo 'Error: ' . $e->getMessage() . '<br>';
		}

	}

}

class UniversalConnect implements IConnectInfo {
	
	private static $servername = IConnectInfo::HOST;
	private static $dbname = IConnectInfo::DBNAME;
	private static $username = IConnectInfo::UNAME;
	private static $password = IConnectInfo::PW;
	private static $conn;

	public static function doConnect() {
		self::$conn = new \PDO('mysql::host=' . self::$servername . ';dbname=' . self::$dbname, self::$username, self::$password);
		self::$conn->setAttribute(\PDO::ATTR_ERRMODE, \PDO::ERRMODE_EXCEPTION);
		return self::$conn;	
	}

}

$judge_client_adapter = new JudgeAdapter();

?>
