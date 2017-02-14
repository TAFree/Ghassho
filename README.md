# Ghassho
A judge client for TAFree1.0 executing in Docker container.

## Prerequisite
```
sudo apt-get install docker....(unfinished)
```

## Build and Run in Docker  
Please maintain related prerequisites in Dockerfile.
```
sudo docker pull ...(unfinished)  
sudo docker run ...
```

## Build and Run in OS / VM  
Do not forget prerequisites for each judge script and lab assignment. 
```
git clone http://github.com/Tafree/Ghassho.git
cd ./Ghassho
sudo ./judger.sh start
```

## Configuration
Please change database infomation in _Ghassho\JudgeAdapter.php_.
```
interface IConnectInfo {
	const HOST = '45.32.107.147';
	const UNAME = 'ghassho';
	const PW = 'ghasshodb';
	const DBNAME = 'TAFreeDev';
	public static function doConnect();
}
```
