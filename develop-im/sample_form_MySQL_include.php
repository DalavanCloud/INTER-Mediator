<?php 
/*
 * INTER-Mediator Ver.@@@@2@@@@ Released @@@@1@@@@
 * 
 *   by Masayuki Nii  msyk@msyk.net Copyright (c) 2010 Masayuki Nii, All rights reserved.
 * 
 *   This project started at the end of 2009.
 *   INTER-Mediator is supplied under MIT License.
 */
require_once ( 'INTER-Mediator/INTER-Mediator.php');

$tableDefs 
	= array(	
		array(	'records'	=>	2,
				'name' 		=> 'person', 
				'key' 		=> 'id',
				'query'		=> array( /* array( 'field'=>'id', 'value'=>'5', 'operator'=>'eq' ),*/ ),
				'sort'		=> array( array( 'field'=>'id', 'direction'=>'asc' ),),),
		array(	'name'			=> 'contact',
				'key'			=> 'id',
				'foreign-key'	=> 'person_id',
				'join-field' 	=> 'id'),
		array(	'name' 	=> 'contact_way',
				 'key' 	=> 'id',),
		array(	'name' 		=> 'cor_way_kindname', 
				'key' 		=> 'id',
				'foreign-key' => 'way_id',
				'join-field' 	=> 'way'),
		array(	'name' 			=> 'history', 
				'key' 			=> 'id',
				'foreign-key'	=> 'person_id',
				'repeat-control'	=> 'insert',
				'join-field' 	=> 'id',	),
		array(	
			'name' 	=> 'postalcode', 
			'query'	=> array( array( 'field'=>'f9', 'value'=>'落合', 'operator'=>'cn' ) ),
			'sort'	=> array( array( 'field'=>'f3', 'direction'=>'ascend' ),),
		),
	);
	
$optionDefs
	= array(
		'formatter' => array(
		)
	);

$dbDefs = array( 'db-class' => 'MySQL', 'db' => 'test_db' );

IM_Entry( $tableDefs, $optionDefs, $dbDefs, true );

?>