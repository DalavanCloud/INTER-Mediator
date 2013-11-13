<?php
/**
 * Created by JetBrains PhpStorm.
 * User: msyk
 * Date: 12/03/26
 * Time: 13:27
 * To change this template use File | Settings | File Templates.
 */
require_once(dirname(__FILE__) . '/../INTER-Mediator/phpseclib/Crypt/RSA.php');
require_once(dirname(__FILE__) . '/../INTER-Mediator/phpseclib/Math/BigInteger.php');

class RSA_Test extends PHPUnit_Framework_TestCase
{
    protected function setUp()
    {
        mb_internal_encoding('UTF-8');
        date_default_timezone_set('Asia/Tokyo');
    }

    public function testGeneratedKey()
    {
        $publickey = null;
        $privatekey = null;
        $rsa = new Crypt_RSA();
        extract($rsa->createKey(512)); /* 128, 256 didn't work, 512, 1024 work, 2048 didn't finish in 5 min. */
        $rsa->loadKey($publickey, CRYPT_RSA_PRIVATE_FORMAT_PKCS1);
//        echo "privatekey=",$privatekey,"\n";
//        echo "publickey=",$publickey,"\n";
        $str = "123";
        $enc = $rsa->encrypt($str);
//        echo "encoded=",$enc,"\n";
        $rsa->loadKey($privatekey, CRYPT_RSA_PRIVATE_FORMAT_PKCS1);
        $dec = $rsa->decrypt($enc);
        $this->assertEquals($str, $dec, "Basic Encrypt/Decrypt with Generated Key");
    }

    public function testSuppliedKey()
    {
        // $ openssl genrsa -out key.pem 512
        $generatedKey = <<<EOL
-----BEGIN RSA PRIVATE KEY-----
MIIBOwIBAAJBAKihibtt92M6A/z49CqNcWugBd3sPrW3HF8TtKANZd1EWQ/agZ65
H2/NdL8H6zCgmKpYFTqFGwlYrnWrsbD1UxcCAwEAAQJAWX5pl1Q0D7Axf6csBg1M
3V5u3qlLWqsUXo0ZtjuGDRgk5FsJOA9bkxfpJspbr2CFkodpBuBCBYpOTQhLUc2H
MQIhAN1stwI2BIiSBNbDx2YiW5IVTEh/gTEXxOCazRDNWPQJAiEAwvZvqIQLexer
TnKj7q+Zcv4G2XgbkhtaLH/ELiA/Fh8CIQDGIC3M86qwzP85cCrub5XCK/567GQc
GmmWk80j2KpciQIhAI/ybFa7x85Gl5EAS9F7jYy9ykjeyVyDHX0liK+V1355AiAG
jU6zr1wG9awuXj8j5x37eFXnfD/p92GpteyHuIDpog==
-----END RSA PRIVATE KEY-----
EOL;
        // $ openssl rsa -pubout -in key.pem
        $publickey = <<<EOL
-----BEGIN PUBLIC KEY-----
MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAKihibtt92M6A/z49CqNcWugBd3sPrW3
HF8TtKANZd1EWQ/agZ65H2/NdL8H6zCgmKpYFTqFGwlYrnWrsbD1UxcCAwEAAQ==
-----END PUBLIC KEY-----
EOL;


        $rsa = new Crypt_RSA();
        $rsa->loadKey($publickey);
        $str = "123";
        $enc = $rsa->encrypt($str);
//        echo "encoded=",bin2hex($enc),"\n";
        $rsa->loadKey($generatedKey);
        $dec = $rsa->decrypt($enc);
        $this->assertEquals($str, $dec, "Basic Encrypt/Decrypt with Supplied key.");
    }

    public function testSuppliedKeyAndData()
    {
        $str = "123";
        // generated by JavaScript RSA library on ondave.com.
        //   $data = "962e3b91a0b9815e0dca40a7595b5603211cee2992abf6054eae20b435d015ef3f54d4daf4cb4370db4c4c6f8432e49b9b81acfb6e1f5e7635bf72a74b29f272";

        // One of generated by openssl rsautl -encrypt -pubin -inkey pub.pem -in data -out enc
        $data = "1c4555cf53c88c1eedfc13db58ccf7f89c1a090fd159427658e5e5743e5c5e9129a716907efe4a76f25046598e92081e75d9217be4c56efd0df06e4507af4f04";
        $generatedKey = <<<EOL
-----BEGIN RSA PRIVATE KEY-----
MIIBOwIBAAJBAKihibtt92M6A/z49CqNcWugBd3sPrW3HF8TtKANZd1EWQ/agZ65
H2/NdL8H6zCgmKpYFTqFGwlYrnWrsbD1UxcCAwEAAQJAWX5pl1Q0D7Axf6csBg1M
3V5u3qlLWqsUXo0ZtjuGDRgk5FsJOA9bkxfpJspbr2CFkodpBuBCBYpOTQhLUc2H
MQIhAN1stwI2BIiSBNbDx2YiW5IVTEh/gTEXxOCazRDNWPQJAiEAwvZvqIQLexer
TnKj7q+Zcv4G2XgbkhtaLH/ELiA/Fh8CIQDGIC3M86qwzP85cCrub5XCK/567GQc
GmmWk80j2KpciQIhAI/ybFa7x85Gl5EAS9F7jYy9ykjeyVyDHX0liK+V1355AiAG
jU6zr1wG9awuXj8j5x37eFXnfD/p92GpteyHuIDpog==
-----END RSA PRIVATE KEY-----
EOL;
//        if ( strlen($data) %2 != 0 )    {
//            $data = '0' . $data;
//        }
//        $temp = '';
//        for ( $i = 0 ; $i < strlen($data) ; $i += 2 )   {
//            $temp .= substr( $data, strlen($data)-2-$i, 2 );
//        }
//        $data = $temp;

        $rsa = new Crypt_RSA();
        $rsa->loadKey($generatedKey);
        $rsa->setEncryptionMode(CRYPT_RSA_ENCRYPTION_PKCS1);
        $dec = $rsa->decrypt(pack("H*", $data));
        $this->assertEquals($str, $dec, "Decrypt with Supplied key.");
    }
}