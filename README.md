# Ghassho
A judge client for TAFree1.0.

## Prerequisite
Ubuntu 16.04 LTS  
Docker 1.13.1 (Optional)

## Build and Run in Docker Container 
Please install packages for compiling and executing lab assignments.  
Oracle JDK 9 is already available.
```  
sudo docker run -it derailment/ghassho:latest
cd /home/Ghassho
```
Change database information
```
mv JudgeAdapter.php.example JudgeAdapter.php
vi JudgeAdapter.php
```
Run
```
./judger.sh start
```

## Build and Run in OS / VM  
Do not forget to install packages for each judge script and lab assignment. 
```
sudo git clone http://github.com/Tafree/Ghassho.git
cd ./Ghassho
```
Change database information
```
sudo mv JudgeAdapter.php.example JudgeAdapter.php
sudo vi JudgeAdapter.php
```
Run
```
sudo ./judger.sh start
```

## Configuration
Please change database information in _Ghassho/JudgeAdapter.php_.
```
interface IConnectInfo {
	const HOST = '45.32.107.147';
	const UNAME = 'account';
	const PW = 'password';
	const DBNAME = 'TAFreeDB';
	public static function doConnect();
}
```

## License
Ghassho is open-sourced software licensed under the [MIT license](http://opensource.org/licenses/MIT).
