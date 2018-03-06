<?php
#ini_set("display_errors", 1);
#ini_set("track_errors", 1);
#ini_set("html_errors", 1);
#error_reporting(E_ALL);

function cfban($ipaddr){
	$cfheaders = array(
		'Content-Type: application/json',
		'X-Auth-Email: nickoplier@gmail.com',
		'X-Auth-Key: e669f83af807aa7bf48'
	);
	$data = array(
		'mode' => 'block',
		'configuration' => array('target' => 'ip', 'value' => $ipaddr),
		'notes' => 'Banned on '.date('Y-m-d H:i:s').' auto for REVERSING CODE.'
	);
	$json = json_encode($data);
	$ch = curl_init();
	curl_setopt($ch, CURLOPT_POSTFIELDS, $json);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	curl_setopt($ch, CURLOPT_HTTPHEADER, $cfheaders);
	curl_setopt($ch, CURLOPT_URL, 'https://api.cloudflare.com/client/v4/user/firewall/access_rules/rules');
	$return = curl_exec($ch);
	curl_close($ch);
	if ($return === false){
		return false;
	}else{
		$return = json_decode($return,true);
		if(isset($return['success']) && $return['success'] == true){
			return $return['result']['id'];
		}else{
			return false;
		}
	}
}

if (!startsWith($_SERVER['REMOTE_ADDR'],"192.168.88.") && $_SERVER['REMOTE_ADDR']!="127.0.0.1" && $_SERVER["HTTP_CF_CONNECTING_IP"]!="**.145.68.194"){
	echo "Your IP is now banned from inF* and your IP has been logged! -- ";
	echo $_SERVER["HTTP_CF_CONNECTING_IP"];
	cfban($_SERVER["HTTP_CF_CONNECTING_IP"]);
	cfban($_SERVER['REMOTE_ADDR']);
	exit;
}


$hostip="**.145.68.194"; //**.145.68.194

$keys="slappystoptrying";

function getToken($cookie) {
	include_once('simple_html_dom.php');
	$request = new HttpRequest();
	$request->setUrl('https://finobe.com/xtokeninf');
	$request->setMethod(HTTP_METH_GET);

	$request->setHeaders(array(
	  'cache-control' => 'no-cache',
	  'cookie' => $cookie,
	  'accept-language' => 'en-US,en;q=0.9',
	  'dnt' => '1',
	  'accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,;q=0.8',
	  'user-agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36',
	  'content-type' => 'application/x-www-form-urlencoded',
	  'upgrade-insecure-requests' => '1',
	  'origin' => 'https://finobe.com'
	));

	try {
	  $response = $request->send();

	 // echo "<br><br><br><br><br><br>" . $response->getBody() . "<br><br><br><br><br><br>";
	  $html = str_get_html($response);
	  return $html->find("meta[name=csrf-token]",0)->content;
	} catch (HttpException $ex) {
	  echo $ex;
	}
}
function loginCheckup() {
	include_once('simple_html_dom.php');
	$cookiesfile=file_get_contents("C:/Users/nicen/Documents/finobehandler/cookiehandler.txt");

	//echo "Going to try cookie... " . $cookiesfile;
	$request = new HttpRequest();
	$request->setUrl('https://finobe.com/character');
	$request->setMethod(HTTP_METH_GET);

	$request->setHeaders(array(
	  'cache-control' => 'no-cache',
	  'cookie' => $cookiesfile,
	  'accept-language' => 'en-US,en;q=0.9',
	  'accept-encoding' => 'gzip, deflate, br',
	  'dnt' => '1',
	  'accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,;q=0.8',
	  'user-agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36',
	  'content-type' => 'application/x-www-form-urlencoded',
	  'upgrade-insecure-requests' => '1',
	  'origin' => 'https://finobe.com'
	));
	//echo "stage1<br>";
	try {
		$response = $request->send();
		$html = str_get_html($response);
		//echo $response->getBody();
		$title = $html->find('title',0);
		//echo "Body of this message! " . $response->getBody();
		if ((isset($title)) && 
			$title->plaintext=="Redirecting to https://finobe.com/login"
		) {
			
			//start get new cookie process
			 
			 //get new token
			$request = new HttpRequest();
			$request->setUrl('https://finobe.com/login');
			$request->setMethod(HTTP_METH_GET);

			$request->setHeaders(array(
			  'Postman-Token' => 'b03c712e-2317-250b-09e9-989c841f91dd',
			  'Cache-Control' => 'no-cache'
			));
			
			$mynewtoken="";
			$mynewfinobesession="";

			//echo "stage2<br>";
			
			try {
				$response = $request->send();
				$html = str_get_html($response);
				$mynewtoken = $html->find("meta[name=csrf-token]",0)->content;
				$newcookiex=$response->getHeader('Set-Cookie');
				$fullcookie="";
				foreach($newcookiex as $key => $value){
					$eexe=explode(";", $newcookiex[$key]);
					$fullcookie=$fullcookie . $eexe[0] . "; ";
				}
				$mynewfinobesession=$newcookiex[2];
			} catch (HttpException $ex) {
				echo $ex;
			}
			
			//echo "<br><br><br>stage3<br><br><br><br>";

							
				$request = new HttpRequest();
				$request->setUrl('https://finobe.com/login');
				$request->setMethod(HTTP_METH_POST);

				$request->setHeaders(array(
				  'Postman-Token' => '6432bef4-a24a-5e25-1cd6-9f0d70d8c31a',
				  'Cache-Control' => 'no-cache',
				  'Cookie' => $fullcookie,
				  'Content-Type' => 'application/x-www-form-urlencoded'
				));

				$request->setContentType('application/x-www-form-urlencoded');
				$request->setPostFields(array(
				  '_token' => $mynewtoken,
				  'login' => 'nickoakz',
				  'password' => 'fuck you no back off ;)'
				));

				try {
				  $response = $request->send();
					$newcookiex=$response->getHeader('Set-Cookie');
					//echo "MyNewCOOKIE";
					$fullcookie="";
					foreach($newcookiex as $key => $value){
						$eexe=explode(";", $newcookiex[$key]);
						$fullcookie=$fullcookie . $eexe[0] . "; ";
					}
				} catch (HttpException $ex) {
				  echo $ex;
				}
			
			//echo "<br><br><br>stage4<br><br><br><br>";
			
			//save new cookie...
			file_put_contents("C:/Users/nicen/Documents/finobehandler/cookiehandler.txt",$fullcookie);
			
			//fuck yes, we're done!
			echo "<br><br><br>stage11<br><br><br><br>";
			return $fullcookie;
			
			
		} else {
			//echo "I'm a happy cookie!";
			return $cookiesfile;
		}
	} catch (HttpException $ex) {
	  echo $ex;
	}
}
function updateName($x,$token,$cookies,$gameid){
	/*
	$request = new HttpRequest();
$request->setUrl('https://finobe.com/game/27199/settings');
$request->setMethod(HTTP_METH_POST);

$request->setHeaders(array(
  'postman-token' => 'd218cf9b-767f-5c06-1a26-ea6ee5f0f802',
  'cache-control' => 'no-cache',
  'cookie' => '__cfduid=d5249687b8c22d5b707b5f8f2e75c62981514257649; _ga=GA1.2.1831578130.1514598855; remember_web_59ba36addc2b2f9401580f014c7f58ea4e30989d=eyJpdiI6Inl0M3B6bXlUZUFFVjNCZ2QwdksxWGc9PSIsInZhbHVlIjoiek5GTWJEVGZmT1FHWFRMekliSkpnZTNFNjhrNVRUTWFMUG1xcUZPQ203TVFKaWZsWkcxbHkrV1RZWkk5bzZXM1JWMHFZN3l3XC9oeDJtSTU1Nit2WVwvOEpVc2JGa0NtdTJ6cEx2d0VoK2NPVmNnZ040WmVoU1ZTZnlsU3JhZXBqOGNJZWJwb0JmcTJMbVlWdHdjZUpWMElhVXNQVUszMk5nU0ZZcnBWTUx0MldlTnJcL3pYQnplUTRQZ0U4SGtNR1JIIiwibWFjIjoiZDhlNTQ5NWM5M2Y5YWE2MmE0NTZiNTc0MTUyYWQyNmYzNjYyNTMwNmI5ZjJjYzU5MTlmZDJiYzJkYjdlNzlmMSJ9; XSRF-TOKEN=eyJpdiI6IlJZWnlTT1JETjd3cFpuRkVVT2Y4eXc9PSIsInZhbHVlIjoiVGx4bHAzYlB6YVwvR25lMzFPaGI2SUIrNGZZS0tDaVNxMU16ZlRxZEpnUzFiaFVXUDU0a09pc3lPSWdBTjE5RGJicm1mOXVYQWtWZkNPVVkrdkdLNU53PT0iLCJtYWMiOiIxNGJhZWYwYWQyNmI4NmJmMGMwMjAwYWM2MjYzOGVlYjNmYzMwN2IzMDYxYWY5MzgxOWM1YTllOGU4ZTJkOGFjIn0%3D; finobe_session=eyJpdiI6Im03ZUNcLzZXamxkM2pFYThvNDdYTURBPT0iLCJ2YWx1ZSI6Im5GdDFoeUMwKzNZWUZLMVJtSHF3ZXRXeVJ3SUluSHVzZ0E3K01QeExsNjFtc001WUZyY0Fwd20yc004T1VpS0xLcnk2aUl6RGoxa0lqZzZaOXVib1RnPT0iLCJtYWMiOiJlZTBiYjg4MjA1ZGFlNGQyYTE4MzAyMjc4ZGYyMTY4ZTIxMzVlM2Y1NGIwMGJlMjgzMjIyODc4ZjQ0MjIwMDA4In0%3D',
  'accept-language' => 'en-US,en;q=0.9',
  'accept-encoding' => 'gzip, deflate, br',
  'referer' => 'https://finobe.com/game/27199/settings',
  'dnt' => '1',
  'accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,;q=0.8',
  'user-agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36',
  'content-type' => 'application/x-www-form-urlencoded',
  'upgrade-insecure-requests' => '1',
  'origin' => 'https://finobe.com'
));

$request->setContentType('application/x-www-form-urlencoded');
$request->setPostFields(array(
  
));

try {
  $response = $request->send();

  echo $response->getBody();
} catch (HttpException $ex) {
  echo $ex;
}
	*/
	
	
	$request = new HttpRequest();
	$request->setUrl('https://finobe.com/game/'. $gameid .'/settings');
	//echo 'check url' . 'https://finobe.com/game/'. $gameid .'/settings';
	$request->setMethod(HTTP_METH_POST);

	$request->setHeaders(array(
	  'cache-control' => 'no-cache',
	  'cookie' => $cookies,
	  'accept-language' => 'en-US,en;q=0.8',
	  'referer' => 'https://finobe.com/games/new',
	  'dnt' => '1',
	  'accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',
	  'user-agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36',
	  'content-type' => 'application/x-www-form-urlencoded',
	  'upgrade-insecure-requests' => '1',
	  'origin' => 'https://finobe.com'
	));

	$request->setContentType('application/x-www-form-urlencoded');
	$request->setPostFields(array(
	  '_token' => $token,
	  'name' => $x,
	  'description' => 'Hello pall, this is the final inF run!',
	  'allowMusicalGear' => 'true',
	  'allowSocialGear' => 'true',
	  'loopback_matchip' => '127.0.0.1',
	  'loopback_ip' => '127.0.0.1',
	  'respawn_time' => '5',
	  'max_players' => '50'
	));

	try {
	  $response = $request->send();
		echo "Name has been set!";
	  //echo $response->getBody();
	} catch (HttpException $ex) {
	  echo $ex;
	}
}

function isrun($x){
	$stest=exec('tasklist /nh /fo CSV /fi "WINDOWTITLE eq Finobe - [' . $x . ']');	
	#echo "is testing '".$stest."' with '" . $x . "' end of test";
	return $stest;
};
function ahk(){
	$wmi = new COM('winmgmts://'); 
	$processes = $wmi->ExecQuery("SELECT * FROM Win32_Process WHERE Name = 'autohotkey.exe'"); 
	$numbssz = 0;
	foreach($processes as $process){ 
		$numbssz++;
	};
	return $numbssz;
};

function startsWith($haystack, $needle)
{
     $length = strlen($needle);
     return (substr($haystack, 0, $length) === $needle);
}

$x="";
$filepath = "C:\\Users\\nicen\\Documents\\finobehandler";
if (isset($_GET['s'])) {
	$x=$_GET['s'];
	if ($x=="logintest"){
		set_time_limit(3);
		$cookies=loginCheckup();
		$token=getToken($cookies);
		//echo "<br>Login Test";
		//echo "fullcookie:<br><br>";
		//echo $cookies;
		//echo "<br><br>fulltoken:<br><br>";
		//echo $token;
		//echo "<br>end";
		echo 'pass';
	}elseif ($x=="discordmsg") {
		$data='';
		$xz=$_GET['hook'];
		if ($xz=='1') {
			$data='https://discordapp.com/api/webhooks/396100755020316682/K7IQzQ-BB0i9minTaraL2XF1Sxu9o9aIKfjTzSVnsQM_zpMSoqrujcGG_fkF6PXAkEFh';
		}
		if ($xz=='2') {
			$data='https://discordapp.com/api/webhooks/396101422359379968/2Yylz_nf3XkLX1WPbwaJ7stbtSBHQ8NW5Ux2WgmgNEEZmM4ifG61dc6V-XGBXOkXN2S7';
		}
		if ($xz=='3') {
			$data='https://discordapp.com/api/webhooks/396190468578476032/mH67nnpqCJJsXJAK8va85Qm37GkDcTtqJcGNxprzofg-Isy2ocT8NRLEwokXnWx37zR0';
		}
		if ($xz=='4') {
			$data='https://discordapp.com/api/webhooks/396191580220030998/i5KdiFjy8yoRy-YXDVSdpKyeS8Sas7VT8MrECqDBW1zF3rJs3VIpUn0OcEe7rH7NLSsT';
		}
		if ($xz=='5') {
			$data='https://discordapp.com/api/webhooks/396200009151938561/0gLWwWFhvmCwmNG68gZdMGmnknT74BAxxXb-BSlFoTH6a3tcpVhuCCi5f6D8RxPf1Psp';
		}
		$request = new HttpRequest();
		$request->setUrl($data);
		$request->setMethod(HTTP_METH_POST);

		$request->setHeaders(array(
		  'postman-token' => '5af88841-6313-0fba-d875-fb8a94af0672',
		  'cache-control' => 'no-cache',
		  'content-type' => 'application/x-www-form-urlencoded'
		));

		$request->setContentType('application/x-www-form-urlencoded');
		$request->setPostFields(array(
		  'content' => $_GET['msg'],
		  'tts' => 'true',
		  'username' => 'FinOtif'
		));

		try {
		  $response = $request->send();

		  //echo $response->getBody();
		} catch (HttpException $ex) {
		  echo $ex;
		}
	} elseif ($x=="demoip"){
		echo "<br><br>Your true responce ip is ";
		echo $_SERVER['REMOTE_ADDR'];
		if (!empty($_SERVER['HTTP_CLIENT_IP'])) {
			echo "<br><br>Your HTTPCLIENTIP is " + $_SERVER['HTTP_CLIENT_IP'];
		} else {
			echo "<br><br>Your HTTPCLIENTIP is n/a";
		}
		if (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
			echo "<br><br>Your HTTP_X_FORWARDED_FOR IP is " + $_SERVER['HTTP_X_FORWARDED_FOR'];
		} else {
			echo "<br><br>Your HTTP_X_FORWARDED_FOR IP is n/a";
		}
	} elseif ($x=="discordmsgnew"){

		$data='';
		$xz=$_GET['hook'];
		if ($xz=='1') {
			$data='https://discordapp.com/api/webhooks/396100755020316682/K7IQzQ-BB0i9minTaraL2XF1Sxu9o9aIKfjTzSVnsQM_zpMSoqrujcGG_fkF6PXAkEFh';
		}
		if ($xz=='2') {
			$data='https://discordapp.com/api/webhooks/396101422359379968/2Yylz_nf3XkLX1WPbwaJ7stbtSBHQ8NW5Ux2WgmgNEEZmM4ifG61dc6V-XGBXOkXN2S7';
		}
		if ($xz=='3') {
			$data='https://discordapp.com/api/webhooks/396190468578476032/mH67nnpqCJJsXJAK8va85Qm37GkDcTtqJcGNxprzofg-Isy2ocT8NRLEwokXnWx37zR0';
		}
		if ($xz=='4') {
			$data='https://discordapp.com/api/webhooks/396191580220030998/i5KdiFjy8yoRy-YXDVSdpKyeS8Sas7VT8MrECqDBW1zF3rJs3VIpUn0OcEe7rH7NLSsT';
		}
		if ($xz=='5') {
			$data='https://discordapp.com/api/webhooks/396200009151938561/0gLWwWFhvmCwmNG68gZdMGmnknT74BAxxXb-BSlFoTH6a3tcpVhuCCi5f6D8RxPf1Psp';
		}
		
		$request = new HttpRequest();
		$request->setUrl($data);
		$request->setMethod(HTTP_METH_POST);

		$request->setHeaders(array(
		  'content-type' => 'application/json'
		));
		
		if ($_GET['waspriced']=="hide") { //is hide?
$request->setBody('{
  "username": "FinOtif",
  "embeds": [{
	"title": "' . $_GET['content'] . '",
	"url": "https://finobe.com/item/' . $_GET['itemid'] . '",
	"thumbnail": {
      "url": "https://finobe.com/catalog/getthumb/' . $_GET['itemid'] . '"
    },
	"fields": [
	  {
		"name": "Price now",
		"value": "'. $_GET['nowpriced'] .' dius",
		"inline": true
	  }
	]
  }]
}');
		} else {
$request->setBody('{
  "username": "FinOtif",
  "embeds": [{
	"title": "' . $_GET['content'] . '",
	"url": "https://finobe.com/item/' . $_GET['itemid'] . '",
	"thumbnail": {
      "url": "https://finobe.com/catalog/getthumb/' . $_GET['itemid'] . '"
    },
	"fields": [
	  {
		"name": "Price was",
		"value": "'.$_GET['waspriced'].' dius",
		"inline": true
	  },
	  {
		"name": "Difference",
		"value": "'.($_GET['waspriced']-$_GET['nowpriced']).' dius",
		"inline": true
	  },
	  {
		"name": "Price now",
		"value": "'.$_GET['nowpriced'].' dius",
		"inline": true
	  }
	]
  }]
}');
		}

		

		try {
		  $response = $request->send();

		  echo $response->getBody();
		} catch (HttpException $ex) {
		  echo $ex;
		}
	} elseif ($x=="latesthats"){
		set_time_limit(24);
		$cookies=loginCheckup();
		$token=getToken($cookies);
		include_once('simple_html_dom.php');
		
		$request = new HttpRequest();
		$request->setUrl("https://finobe.com/catalog/hats?page=1");
		$request->setMethod(HTTP_METH_GET);

		$request->setHeaders(array(
		  'cookie' => $cookies,
		  'content-type' => 'application/x-www-form-urlencoded',
		  'cache-control' => 'no-cache'
		));

		try {
			$response = $request->send();
			$body = $response->getBody();
			//echo $body;
			$html = str_get_html($body);
			//echo "Trying to get data..." + $html;
			//catalog-card
			#echo "did i find one?";
			$list=array();
			foreach($html->find('a[class="catalog-card"]') as $element) {
				//array_push($list,$element->find('a[class="catalog-card-name"]')->plaintext);
				$xrx=$element->find('p[class="catalog-card-name"]',0);
				$pri=$element->find('p[class="my-0 catalog-no-overflow-plz"]',0);
				$pri = explode("(",$pri->plaintext)[0];
				$res = preg_replace("/[^0-9,.]/", "", $pri );
				$xexa = preg_replace("/[^0-9,]/", "", $element->href );
				echo $xrx->plaintext . "---" . $res . "---" . $xexa . "|||";
			};
		} catch (HttpException $ex) {
		  echo $ex;
		}
		// https://finobe.com/catalog
	} elseif ($x=="alllimhats"){
		set_time_limit(30);
		$cookies=loginCheckup();
		$token=getToken($cookies);
		include_once('simple_html_dom.php');
		$repeater=true;
		$page=1;
		while($repeater){
			$request = new HttpRequest();
			$request->setUrl("https://finobe.com/catalog/hats?page=" . $page . "&lu=1");
			$page++;
			$request->setMethod(HTTP_METH_GET);

			$request->setHeaders(array(
			  'cookie' => $cookies,
			  'content-type' => 'application/x-www-form-urlencoded',
			  'cache-control' => 'no-cache'
			));

			try {
				$response = $request->send();
				$body = $response->getBody();
				//echo $body;
				$html = str_get_html($body);
				//echo "Trying to get data..." + $html;
				//catalog-card
				#echo "did i find one?";
				$keepgoing=false;
				$list=array();
				foreach($html->find('a[class="catalog-card"]') as $element) {
					//array_push($list,$element->find('a[class="catalog-card-name"]')->plaintext);
					$xrx=$element->find('p[class="catalog-card-name"]',0);
					$pri=$element->find('p[class="my-0 catalog-no-overflow-plz"]',0);
					$pri = explode("(",$pri->plaintext)[0];
					$res = preg_replace("/[^0-9,.]/", "", $pri );
					$xexa = preg_replace("/[^0-9,]/", "", $element->href );
					echo $xrx->plaintext . "---" . $res . "---" . $xexa . "|||";
					$keepgoing=true;
				};
				if ($keepgoing==false) $repeater=false;
			} catch (HttpException $ex) {
			  echo $ex;
			  $repeater=false;
			}
		}
		// https://finobe.com/catalog
	} elseif ($x=="latestfaces"){
		set_time_limit(24);
		$cookies=loginCheckup();
		$token=getToken($cookies);
		include_once('simple_html_dom.php');
		
		$request = new HttpRequest();
		$request->setUrl("https://finobe.com/catalog/faces?page=1");
		$request->setMethod(HTTP_METH_GET);

		$request->setHeaders(array(
		  'cookie' => $cookies,
		  'content-type' => 'application/x-www-form-urlencoded',
		  'cache-control' => 'no-cache'
		));

		try {
			$response = $request->send();
			$body = $response->getBody();
			//echo $body;
			$html = str_get_html($body);
			//echo "Trying to get data..." + $html;
			//catalog-card
			#echo "did i find one?";
			$list=array();
			foreach($html->find('a[class="catalog-card"]') as $element) {
				//array_push($list,$element->find('a[class="catalog-card-name"]')->plaintext);
				$xrx=$element->find('p[class="catalog-card-name"]',0);
				$pri=$element->find('p[class="my-0 catalog-no-overflow-plz"]',0);
				$res = preg_replace("/[^0-9,.]/", "", $pri->plaintext );
				$xexa = preg_replace("/[^0-9,]/", "", $element->href );
				echo $xrx->plaintext . "---" . $res . "---" . $xexa . "|||";
			};
		} catch (HttpException $ex) {
		  echo $ex;
		}
		// https://finobe.com/catalog
	} elseif ($x=="debug"){
		$cookies=loginCheckup();
		echo getToken($cookies);
	} elseif ($x=="savereq"){
		$cmd=$filepath . '\\save.ahk "' . $_GET['file'] . '"';
		pclose(popen("start /B ".$cmd,"r"));
	} elseif ($x=="startinstance"){
		$isahk=ahk();
		if ($isahk == 0) {
			$check = isrun($_GET['file']);
			$check="INFO: No tasks are running which match the specified criteria.";
			if ($check == "INFO: No tasks are running which match the specified criteria.") {
				$wmi = new COM('winmgmts://'); 
				$processes = $wmi->ExecQuery("SELECT * FROM Win32_Process WHERE Name = 'robloxapp.exe'"); 
				$numberofservers = 0;
				foreach($processes as $process){ 
					$numberofservers++;
				};
				if ($numberofservers<12) {
					echo "Server should be started! Goto the website to join!";
					//ignore_user_abort(true);
					//set_time_limit(0);
					#echo $filepath . '\\startinstance.ahk "' . $_GET['server'] . '" "' . $_GET['file'] . '"';
					if (isset($_GET['neworolddir']) && $_GET['neworolddir']=="true"){
						$filepath=$filepath . "\\uploadedgames";
					}
					if ($_GET['version']=="2012") {
						//$cmd=$filepath . '\\startinstance.ahk "' . $_GET['server'] . '" "' . $_GET['file'] . '"';
						//pclose(popen("start /B ".$cmd,"r"));
						$fileg="_G.file='" . $_GET['file'] . "' _G.giveadmin='" . $_GET['giveadmin'] . "' _G.gameinstance='" . $_GET['gameinstance'] . "'";
						if ($_GET['authorizesave']=="true") {
							$fileg=$fileg . "   _G.saveNSHkeyakgajjksdkfjajgke=true ";
						}
						if (isset($_GET['owner'])) {
							$fileg=$fileg . "   _G.owner='" . $_GET['owner'] . "";
						}
						if (isset($_GET['firstadmin'])) {
							$fileg=$fileg . "   _G.firstadmin='". $_GET['firstadmin'] . "'";
						}
						if (isset($_GET['creator'])) {
							$fileg=$fileg . "   _G.creator='". $_GET['creator'] . "'";
						}
						$cmd='F:\Finobe\2012\RobloxApp.exe "'. $filepath . '\\' . $_GET['file'] . '" -script "' . $fileg . '"  -script "' . "wait(1) loadstring(game:HttpGet('http://www.nickoakzhost.nigga/finobeservers/serverstart.lua?tick=" . floor(time()) ."',true))()" . '" -script "' . $_GET['server'] . '"';
						
						//echo $cmd;
						pclose(popen("start /B ".$cmd,"r"));
					} elseif ($_GET['version']=="2007") {
						//$cmd=$filepath . '\\startinstance2007.ahk "' . $_GET['server'] . '" "' . $_GET['file'] . '"';
						//$cmd=$filepath . '\\startinstance.ahk "' . $_GET['server'] . '" "' . $_GET['file'] . '"';
						//pclose(popen("start /B ".$cmd,"r"));
						$fileg="_G.file='" . $_GET['file'] . "'";
						
						$cmd='F:\Finobe\2007\RobloxApp.exe "'. $filepath . '\\' . $_GET['file'] . '" -script "' . $fileg . '"  -script "' . "wait(1) loadstring(game:HttpGet('http://www.nickoakzhost.nigga/serverstart.lua?v310',true))()" . '" -script "' . $_GET['server'] . '"';
						
						//echo $cmd;
						pclose(popen("start /B ".$cmd,"r"));
					};
				} else {
					echo "Too many servers!";
				}
			} else {
				echo "Server already running!";
			};
		} else {
			echo "Hold on! AHK is running. ";
		}
	} elseif ($x=="isahkon"){
		$check = exec('tasklist /nh /fo CSV /fi "IMAGENAME eq autohotkey.exe"');
		if ($check=="INFO: No tasks are running which match the specified criteria.") {
			echo "AHK off";
		} else {
			echo "AHK on";
		}
	} elseif ($x=="isrunning"){
		$check = isrun($_GET['file']);
		if ($check=="INFO: No tasks are running which match the specified criteria.") {
			echo "Server isn't running";
		} else {
			echo "Server is running";
		}
	} elseif ($x=="killinstance"){
		exec($filepath . '\\killinstance.ahk "' . $_GET['file'] . '"');
		$wmi = new COM('winmgmts://'); 
		$processes = $wmi->ExecQuery("SELECT * FROM Win32_Process WHERE Name = 'robloxapp.exe'"); 
		$numberofservers = 0;
		foreach($processes as $process){ 
			$numberofservers++;
		};
		echo "Server should be killed!";
		$cookies=loginCheckup();
		$token=getToken($cookies);
		$request = new HttpRequest();
		$request->setUrl('https://finobe.com/game/' . $_GET['gameinstance'] . '/delete');
		$request->setMethod(HTTP_METH_POST);

		$request->setHeaders(array(
		  'cookie' => $cookies,
		  'content-type' => 'application/x-www-form-urlencoded',
		  'cache-control' => 'no-cache'
		));

		$request->setContentType('application/x-www-form-urlencoded');
		$request->setPostFields(array(
		  '_token' => $token
		));
		echo "using token `".$token."` ok? \n \\n<br>";

		try {
		  $response = $request->send();

		  echo 'removed ' . $_GET['gameinstance'];
		  echo $response->getBody();
		} catch (HttpException $ex) {
		  echo $ex;
		}
		echo "Instance should be destroyed!";
		
	} elseif ($x=="running"){
		$wmi = new COM('winmgmts://'); 
		$processes = $wmi->ExecQuery("SELECT * FROM Win32_Process WHERE Name = 'robloxapp.exe'"); 
		$numberofservers = 0;
		foreach($processes as $process){ 
			$numberofservers++;
		};
		echo $numberofservers;
	} elseif ($x=="destroyservers"){
		$cookies=loginCheckup();
		$token=getToken($cookies);
		include_once('simple_html_dom.php');
		
		$request = new HttpRequest();
		$request->setUrl("https://finobe.com/user/83448");
		$request->setMethod(HTTP_METH_GET);

		$request->setHeaders(array(
		  'cookie' => $cookies,
		  'content-type' => 'application/x-www-form-urlencoded',
		  'cache-control' => 'no-cache'
		));

		try {
			$response = $request->send();
			$body = $response->getBody();
			echo $body;
			$html = str_get_html($body);
			echo "Trying to get data..." + $html;
			$list = array();
			foreach($html->find('a[class="btn btn-danger btn-block"]') as $element) {
				array_push($list,preg_replace("/[^0-9]/","",$element->href));
				echo "Found a code! > " . $element->href . "<br><br>";
			};
			//set_time_limit(5);
			foreach($list as $exp) {
				echo "found " . $exp;
				if ($exp != "18484" && $exp != "18404" && $exp != "18397" ){
					$request = new HttpRequest();
					$request->setUrl('https://finobe.com/game/' . $exp . '/delete');
					$request->setMethod(HTTP_METH_POST);

					$request->setHeaders(array(
					  'cookie' => $cookies,
					  'content-type' => 'application/x-www-form-urlencoded',
					  'cache-control' => 'no-cache'
					));

					$request->setContentType('application/x-www-form-urlencoded');
					$request->setPostFields(array(
					  '_token' => $token
					));
					echo "using token `".$token."` ok? \n \\n<br>";

					try {
					  $response = $request->send();

					  echo 'removed ' . $exp;
					  //echo $response->getBody();
					} catch (HttpException $ex) {
					  echo $ex;
					}
				}
			};
			#echo "did i find one?";
		} catch (HttpException $ex) {
		  echo $ex;
		}
	} elseif ($x=="setgamename"){
		$cookies=loginCheckup();
		$token=getToken($cookies);
		updateName($_GET['name'],$token,$cookies,$_GET['id']);
	} elseif ($x=="newfinobeserver"){
		$wmi = new COM('winmgmts://'); 
		$processes = $wmi->ExecQuery("SELECT * FROM Win32_Process WHERE Name = 'robloxapp.exe'"); 
		$numberofservers = 0;
		foreach($processes as $process){ 
			$numberofservers++;
		};
		if ($numberofservers<12) {
			$cookies=loginCheckup();
			$token=getToken($cookies);
			//echo "<br>" . "using new token." . $token . "and cookie " . $cookies;
			include_once('simple_html_dom.php');
			
			$request = new HttpRequest();
			$request->setUrl('https://finobe.com/games/new');
			$request->setMethod(HTTP_METH_POST);

			$request->setHeaders(array(
			  'cache-control' => 'no-cache',
			  'cookie' => $cookies,
			  'accept-language' => 'en-US,en;q=0.8',
			  'referer' => 'https://finobe.com/games/new',
			  'dnt' => '1',
			  'accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',
			  'user-agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36',
			  'content-type' => 'application/x-www-form-urlencoded',
			  'upgrade-insecure-requests' => '1',
			  'origin' => 'https://finobe.com'
			));

			$request->setContentType('application/x-www-form-urlencoded');
			$request->setPostFields(array(
			  '_token' => $token,
			  'allowMusicalGear' => 'false',
			  'allowSocialGear' => 'false',
			  'description' => $_GET['desc'] . '..  This game has been opened automatically by NSH/NicksServerHub.',
			  'ip' => $hostip,
			  'max_players' => $_GET['maxplayers'],
			  'name' => $_GET['servername'],
			  'port' => $_GET['serverport'],
			  'respawn_time' => '5',
			  'use_rserver' => 'false',
			  'version' => $_GET['version'],
			  'isHidden' => $_GET['hidden']
			));

			try {
			  $response = $request->send();
			  $gameurl="";
			  
				$newcookie=$response->getHeader('Set-Cookie');
				$fullcookie="";
				//echo "<br>FullBody<br>" . $response->getBody() . "<br>";
				foreach($newcookie as $key => $value){
					$eexe=explode(";", $newcookie[$key]);
					$fullcookie=$fullcookie . $eexe[0] . ";";
				}
				//echo "FullNewCookie<br>" . $fullcookie . "<br>";
				file_put_contents("C:/Users/nicen/Documents/finobehandler/cookiehandler.txt",$fullcookie);
				
				$cookies=$fullcookie;
			  
			  $html = $html = str_get_html($response);

			  foreach($html->find('a') as $element) $gameurl=$element->href;
			  
			  if ($gameurl==""){
				  echo "failure> " . $response;
			  } else {
					#echo $gameurl;
					$request = new HttpRequest();
					#echo "Getting server data '" . $gameurl . "'";
					$request->setUrl($gameurl);
					$request->setMethod(HTTP_METH_GET);

					$request->setHeaders(array(
					  'cookie' => $cookies,
					  'content-type' => 'application/x-www-form-urlencoded',
					  'cache-control' => 'no-cache'
					));

					try {
						$response = $request->send();
						$html = str_get_html($response);
						#echo "Trying to get data...";
						$finalurl=substr($gameurl,23,-6);
						foreach($html->find('code') as $element) {
							echo $finalurl . "==" . $str = str_replace("\n", '', substr(str_replace('"', "'", $element),7,-8));
						};
						#echo "did i find one?";
					} catch (HttpException $ex) {
					  echo $ex;
					}
			  };
			  
			} catch (HttpException $ex) {
			  echo $ex;
			}
		} else {
			echo "Too many servers";
		}
	} elseif ($x=="getgamestable"){
		// connect
		$m = new MongoClient();
		// select a database
		$db = $m->GameDB;
		// select a collection (analogous to a relational database's table)
		$collection = $db->gamestable;
		$person = array("gameID" => $_GET['file']);
		$cursor = $collection->find($person);
		$goodtwelve = 0;
		$alltwelve = 0;
		$goodseven = 0;
		$allseven = 0;
		$total = 0;
		foreach ($cursor as $document) {
			if ($document["version"]==2012) {
				if ($document["stable"]==1) {
					$goodtwelve++; 
				} 
				$alltwelve++;
			} elseif ($document["version"]==2007) {
				if ($document["stable"]==1) {
					$goodseven++; 
				};
				$allseven++;
			}
			$total++;
		};
		echo $goodtwelve . "=" . $alltwelve . "|" . $goodseven . "=" . $allseven . "|" . $total;
	} elseif ($x=="dogamestable") {
		// connect
		$m = new MongoClient();
		// select a database
		$db = $m->GameDB;
		// select a collection (analogous to a relational database's table)
		$collection = $db->gamestable;
		$document = array(
			"gameID" => $_GET['file'],
			"version" => $_GET['version'],
			"stable" => $_GET['stable']
		);
		$collection->insert($document);
	} elseif ($x=="getcomments"){
		// connect
		$m = new MongoClient();
		// select a database
		$db = $m->GameDB;
		// select a collection (analogous to a relational database's table)
		$collection = $db->comments;
		$person = array("gameID" => $_GET['file']);
		$cursor = $collection->find($person)->sort(array("_id"=>-1))->limit(10);
		# .find().sort({_id : -1 }).limit(10);
		# echo sizeof($cursor);
		# $arr = array_slice($document, -10);
		# echo $cursor;
		foreach ($cursor as $document) {
			echo $document["userID"] . ": " . $document["message"] . "\n";
		}
	} elseif ($x=="getvotes"){
		// connect
		$m = new MongoClient();
		// select a database
		$db = $m->GameDB;
		// select a collection (analogous to a relational database's table)
		$collection = $db->votes;
		$person = array("gameID" => $_GET['file']);
		$cursor = $collection->find($person);
		$votenum = 0;
		$votes = 0;
		foreach ($cursor as $document) {
			if ($document["vote"]==1) {
				$votenum++; 
			} elseif ($document["vote"]==-1) {
				// $votenum--;
			}
			$votes++;
		};
		echo $votenum . "=" . $votes;
	} elseif ($x=="addcomment") {
		// connect
		$m = new MongoClient();
		// select a database
		$db = $m->GameDB;
		// select a collection (analogous to a relational database's table)
		$collection = $db->comments;
		$document = array(
			"gameID" => $_GET['file'],
			"userID" => $_GET['userid'],
			"message" => $_GET['message']
		);
		$collection->insert($document);
	} elseif ($x=="addvote"){
		// connect
		$m = new MongoClient();
		// select a database
		$db = $m->GameDB;
		// select a collection (analogous to a relational database's table)
		$collection = $db->votes;
		$document = array(
			"gameID" => $_GET['file'],
			"userID" => $_GET['userid'],
			"vote" => $_GET['vote']
		);
		$setts = array(
			"upsert" => true,
			"multi" => false
		);
		$collection->update(["gameID" => $_GET['file'],"userID" => $_GET['userid']],$document,$setts);
		$person = array("gameID" => $_GET['file']);
		$cursor = $collection->find($person);
		$votenum = 0;
		$votes = 0;
		foreach ($cursor as $document) {
			if ($document["vote"]==1) {
				$votenum++; 
			} elseif ($document["vote"]==-1) {
				// $votenum--;
			}
			$votes++;
		};
		echo $votenum . "=" . $votes;
	} elseif ($x=="gamestart"){
		$m = new MongoClient();
		$db = $m->GameDB;
		$collection = $db->gamestarts;
		$document = array(
			"file" => $_GET['file'],
			"tick" => $_GET['tick']
		);
		$setts = array(
			"upsert" => true,
			"multi" => false
		);
		$collection->update(["file" => $_GET['file']],$document,$setts);
		echo "ok";
	} elseif ($x=="gamestarted"){
		$m = new MongoClient();
		$db = $m->GameDB;
		$collection = $db->gamestarts;
		$game = array("file" => $_GET['file']);
		$cursor = $collection->find($game);
		$gametick = 0;
		foreach ($cursor as $document) {
			$gametick=$document["tick"];
		};
		if ($gametick==0) {
			echo "none";
		} else {
			echo $gametick;
		}
	} elseif ($x=="userpushthebutton"){
		// connect
		$m = new MongoClient();
		// select a database
		$db = $m->GameDB;
		// select a collection (analogous to a relational database's table)
		if ($_GET['v'] = 2) {
			$collection = $db->thebuttontwo;
		} else {
			$collection = $db->thebutton;
		}
		$document = array(
			"user" => $_GET['user'],
			"clicked" => $_GET['clicked']
		);
		$setts = array(
			"upsert" => true,
			"multi" => false
		);
		$collection->update(["user" => $_GET['user']],$document,$setts);
	} elseif ($x=="diduserpushthebutton"){
		$m = new MongoClient();
		$db = $m->GameDB;
		if ($_GET['v'] = 2) {
			$collection = $db->thebuttontwo;
		} else {
			$collection = $db->thebutton;
		}
		$game = array("user" => $_GET['user']);
		$cursor = $collection->find($game);
		$votes=0;
		foreach ($cursor as $document) {
			$votes++;
		};
		echo $votes;
	} elseif ($x=="getgameshouts"){
		$m = new MongoClient();
		$db = $m->GameDB;
		$collection = $db->gameshout;
		$game = array();
		$cursor = $collection->find($game);
		$arr = array();
		error_reporting(E_STRICT);
		foreach($cursor as $c)
		{
			$temp = array(
				"tick" => $c["tick"], 
				"message" => $c["message"], 
				"author" => $c["author"],
				"action" => $c["action"] ?: "none"
			);
			array_push($arr, $temp);
		}

		echo json_encode($arr);
	} elseif ($x=="gameshout"){
		$m = new MongoClient();
		$db = $m->GameDB;
		$collection = $db->gameshout;
		error_reporting(E_STRICT);
		$document = array(
			"tick" => $_GET["tick"], 
			"message" => $_GET["message"], 
			"author" => $_GET["author"],
			"action" => $_GET["action"] ?: "none"
		);
		$collection->insert($document);
		echo "ok";
	} elseif ($x=="scriptuse"){
		$m = new MongoClient();
		$db = $m->GameDB;
		$collection = $db->scriptStorage;
		// error_reporting(E_STRICT);
		$document = array(
			"userID" => $_GET["user"], 
			"gameid" => $_GET["game"],
			"scriptsource" => file_get_contents("php://input")
		);
		$collection->insert($document);
		echo "yay";
	} elseif ($x=="getusergames"){
		$m = new MongoClient();
		$db = $m->inF;
		$collection = $db->usergames;
		$game = array();
		$cursor = $collection->find($game);
		$arr = array();
		error_reporting(E_STRICT);
		foreach($cursor as $c)
		{
			$temp = array(
				"owner" => $c["user"], 
				"gamefile" => $c["game"], 
				"firstadmin" => $c["firstadmin"],
				"ingamesave" => $c["ingamesave"] ?: "none",
				"admins" => $c["admins"] ?: "none"
			);
			array_push($arr, $temp);
		}
		echo json_encode($arr);
		//echo json_encode(iterator_to_array($arr));
	} elseif ($x=="putcontent"){
		// file_put_contents("xx" + $_GET['name'], $_GET['string']);
	} else {
		echo "xx-sorry, don't know what to do...";
	}
} else {
	echo "Wave!, did you mean to do something?";
}


