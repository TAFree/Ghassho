# Ghassho
A judge client for TAFree1.0.

## Prerequisite
Docker 1.13.1

## Build and Run in Docker Container 
Please maintain related prerequisites in Docker Container.
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
Do not forget prerequisites for each judge script and lab assignment. 
```
git clone http://github.com/Tafree/Ghassho.git
cd ./Ghassho
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
