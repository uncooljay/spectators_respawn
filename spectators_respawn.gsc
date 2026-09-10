main()
{
	replacefunc( maps\mp\zombies\_zm::spectators_respawn, ::spectators_respawn );
}

spectators_respawn()
{
	level endon( "between_round_over" );

	if( !isdefined( level.zombie_vars[ "spectators_respawn" ] ) || !level.zombie_vars[ "spectators_respawn" ] )
		return;

	while( true )
	{
		players = common_scripts\utility::get_players();

		for( i = 0; i < players.size; i++ )
		{
			player = players[ i ];
			player spectator_respawn_player();
		}

		wait 1;
	}
}

spectator_respawn_player()
{
	if( self.sessionstate == "spectator" && isdefined( self.spectator_respawn ) )
	{
		if( !isdefined( level.custom_spawnplayer ) )
			level.custom_spawnplayer = maps\mp\zombies\_zm::spectator_respawn;

		self [[ level.spawnplayer ]]();
		self thread refresh_player_navcard_hud();

		// removed: level.spectator_respawn_custom_score -> score was capped regardless
		if( level.round_number > 6 )
		{
			power = int( pow( level.round_number, 2 ) * 20 );
			score = round_to_nearest( power, 100 );

			if( self.score < score )
			{
				self.old_score = self.score;
				self.score = score;
			}
		}
	}
}

round_to_nearest( number, step )
{
	round = number % step;

	if( round <= step / 2 )
		return number - round;
	else
		return number + step - round;
}