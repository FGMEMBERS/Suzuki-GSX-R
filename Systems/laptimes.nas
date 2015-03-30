###############################################################################################
#		Lake of Constance Hangar :: M.Kraus
#		Suzuki GSX-R 1000 for Flightgear August 2014
#		This file is licenced under the terms of the GNU General Public Licence V2 or later
############################################################################################### 
var flaginfo = props.globals.initNode("/controls/flag-info",0,"INT");
var racelap = props.globals.getNode("/Suzuki-GSX-R/race-lap");
var thissector = props.globals.getNode("/Suzuki-GSX-R/this-sector");
# only for mp result view
var sectortime = props.globals.getNode("/Suzuki-GSX-R/this-sector-time");
var laptime = props.globals.getNode("/Suzuki-GSX-R/this-lap-time");
var racetime = props.globals.getNode("/Suzuki-GSX-R/this-race-time");
var inrange = 0;

################# Geo coordinates from the sector start points ############
# names are differnt to the marker, cause the sector is called like the target point

##### Isle of Man - Tourist Trophy

# Ground Marker Position GRANDSTAND - lat,lon,alt in meter
var wp1tt = [54.16670804,-4.48068530,79,"Glen Helen"];

# Ground Sign Position Glen Helen 1 - lat,lon,alt in meter
var wp2tt = [54.22020313,-4.62823605,103,"Ballaugh Bri."];
#var wp2tt = [54.16579896,-4.48260246,74,"Ballaugh Bri."];

# Ground Sign Position Ballaugh Bridge - lat,lon,alt in meter
var wp3tt = [54.30997575,-4.54054979,34,"Ramsey Hair."];
#var wp3tt = [54.16440908,-4.48359348,67,"Ramsey Hair."];

# Ground Sign Position Ramsey Hair - lat,lon,alt in meter
var wp4tt = [54.31322202,-4.38423172,71,"Bungalow"];
#var wp4tt = [54.15898451,-4.47825981,26,"Bungalow"];

# Ground Sign Position Bungalow - lat,lon,alt in meter
var wp5tt = [54.25029998,-4.46338492,412,"Cronk'ny'Mo."];
#var wp5tt = [54.16643048,-4.47100618,61,"Cronk'ny'Mo."];

# Ground Sign Position Crank ny Mona - lat,lon,alt in meter
var wp6tt = [54.18736723,-4.47447412,118,"Grandstand"];
#var wp6tt = [54.17118106,-4.46976795,87,"Grandstand"];

##### Isle of Man - Southern 100

# Ground Marker Position Start/Finish - lat,lon,alt in meter
var wp1s = [54.07972735,-4.66263898,9.0,"Start/Finish"];

# Ground Marker Position Ballabeg-Hairpin - lat,lon,alt in meter
var wp2s = [54.09701733,-4.67597244,15.0,"Ballabeg Hair"];

# Ground Marker Position Cross Four-Ways - lat,lon,alt in meter
var wp3s = [54.09490818,-4.64681461,27.0,"Cross Four-Ways"];

##### North-Ireland - North West 200

# Ground Marker Position FINISH - lat,lon,alt in meter
var wp1nw = [55.19291196,-6.69767340,13,"Finish"];

# Ground Marker Position Ballysally Roundabout - lat,lon,alt in meter
var wp2nw = [55.15706229,-6.66395081,55,"Ballysally"];

# Ground Marker Position Metropole - lat,lon,alt in meter
var wp3nw = [55.19879913,-6.65528507,8,"Metropole"];

##### North-Ireland - Ulster Grand Prix

# Ground Marker Position Grandstand - lat,lon,alt in meter
var wp1ugp = [54.58127383,-6.08652248,233,"Grandstand"];

# Ground Marker Position Quaterlands - lat,lon,alt in meter
var wp2ugp = [54.60847208,-6.11141598,167.0,"Quaterlands"];

##### China - Macau Grand Prix

# Ground Marker Position Start/Finish - lat,lon,alt in meter
var wp1mgp = [22.19920050,113.55963580,6.0,"Start/Finish"];

# Ground Marker Position Maternity - lat,lon,alt in meter
var wp2mgp = [22.19538612,113.54859076,45.0,"Maternity"];

# Ground Marker Position Donna Maria - lat,lon,alt in meter
var wp3mgp = [22.20357370,113.55682861,15.0,"Donna Maria"];

##### Estonia - Kalevi Circuit - Pirita-Klose-Koostrimetsa

# Ground Marker Position Start/Finish - lat,lon,alt in meter
var wp1kal = [59.45979784,24.84072284,27.0,"Start/Finish"];

# Ground Marker Position Plangu Kurv - lat,lon,alt in meter
var wp2kal = [59.46632604,24.86785969,39.0,"Plangu Kurv"];

# Ground Marker Position Pirita Kurv - lat,lon,alt in meter
var wp3kal = [59.46823537,24.83455139,11.0,"Pirita Kurv"];

##### New Zealand - Hampton downs

# Ground Marker Position Start/Finish - lat,lon,alt in meter
var wp1hd = [-37.35664293,175.07731681,20,"Start/Finish"];

# Ground Marker Position S-Bend - lat,lon,alt in meter
var wp2hd = [-37.35426269,175.07525481,15.0,"S-Bend"];

##### New Zealand - Wanganui - Cimetery Circuit

# Ground Marker Position Start/Finish - lat,lon,alt in meter
var wp1cc = [-39.93776583,175.05011601,9.0,"Start/Finish"];

# Ground Marker Position Heads Rd - lat,lon,alt in meter
var wp2cc = [-39.93978927,175.04952614,7.0,"Heads Road"];

##### Czech - Terlicko

# Ground Marker Position Start/Finish - lat,lon,alt in meter
var wp1ct = [49.75945182,18.48839585,283.0,"Start/Cil"];

# Ground Marker Position Rondel - lat,lon,alt in meter
var wp2ct = [49.76191355,18.46498641,337.0,"Rondel"];

# Ground Marker Position Rondel - lat,lon,alt in meter
var wp3ct = [49.77349913,18.48491256,314.0,"Sady"];

var pa = "TT";
var sectors = sectors_tt = [wp1tt, wp2tt, wp3tt, wp4tt, wp5tt, wp6tt];
var sectors_s100 = [wp1s, wp2s, wp3s];
var sectors_nw200 = [wp1nw, wp2nw, wp3nw];
var sectors_ugp = [wp1ugp, wp2ugp];
var sectors_mgp = [wp1mgp, wp2mgp, wp3mgp];
var sectors_kal = [wp1kal, wp2kal, wp3kal];
var sectors_hd = [wp1hd, wp2hd];
var sectors_cc = [wp1cc, wp2cc];
var sectors_ct = [wp1ct, wp2ct, wp3ct];

############################ helper for view ####################################
var show_helper = func(s) {
  var hours = int(s / 3600);
  var minutes = int(math.mod(s / 60, 60));
  var seconds = math.mod(s, 60);
  var timestring = "";
  
	if (hours > 0){
  		timestring = sprintf("%3d:", hours);
	}
	timestring = timestring~sprintf("%02d", minutes);	
	
	if (seconds < 10){
  		timestring = timestring~sprintf(" : 0%.1f", seconds);
	}else{
		timestring = timestring~sprintf(" : %.1f", seconds);
	}	

	return timestring;
}

############################### Show own current lap and sector times ###########################
var total_result = func{
	var maxlaps = getprop("/Suzuki-GSX-R/"~pa~"/race-laps") or 0;
	var tr = 0;
    for(v = 0; v <= maxlaps; v +=1) {
		var actl = getprop("/Suzuki-GSX-R/"~pa~"/lap["~v~"]/actual-time") or 0;
		tr += actl;
	}
	if(racelap.getValue() <= maxlaps) tr += laptime.getValue();
	return tr;
}

var show_lap_and_sector_time = func{
	var show_it = getprop("/Suzuki-GSX-R/show-race-times") or 0;
	var show_l_or_f = getprop("/Suzuki-GSX-R/switch-last-fastest") or 0;

	if(show_it){
		################### build the table ####################
		# offset right 1, top -1, 1 line for lap times, 1.1 sec
		var race_win = screen.window.new( 1, -1, 1, 1.1 );
		race_win.fg = [0.3,0.3,0.3,1]; # color first three rgb - last transparency
		race_win.write("Name");
		var twinpos = 120;
		foreach(var s; sectors) { 
			var race_win = screen.window.new( twinpos, -1, 1, 1.1 );
			race_win.fg = [0.3,0.3,0.3,1];
			race_win.write(s[3]);
			twinpos += 100
		}
		var race_win = screen.window.new( twinpos + 60, -1, 1, 1.1 );
		race_win.fg = [0.3,0.3,0.3,1];
		race_win.write("Lap");
	
		var race_win = screen.window.new( twinpos + 160, -1, 1, 1.1 );
		race_win.fg = [0.3,0.3,0.3,1];
		race_win.write("Total Result");	
		################### table head end ######################
	
		var race_win = screen.window.new( 1, -20, 2, 1.1 );
		race_win.fg = [1,1,1,1]; # color last three rgb
		race_win.write(getprop("/sim/multiplay/callsign"));
		if(show_l_or_f){
			race_win.write("fastest lap");
		}else{
			race_win.write("last lap");
		}
	}

	var winpos = 120;
	var n = 0;
	var lapt = 0;
	
	foreach(var s; sectors) { 
		var race_win = screen.window.new( winpos, -20, 2, 1.1 );
		race_win.fg = [1,1,1,1]; # color last three rgb
	
		if(n > (size(sectors)-1)) { 
			n = 0;
		}
		ln = n-1;
		if(ln < 0) { 
			ln = size(sectors)-1;
		}

		var lsts = getprop("/Suzuki-GSX-R/"~pa~"/sector["~ln~"]/start-time") or 0;
		var sts  = getprop("/Suzuki-GSX-R/"~pa~"/sector["~n~"]/start-time") or 0;
		var lt  = getprop("/Suzuki-GSX-R/"~pa~"/sector["~n~"]/last-time") or 0;
		var ft  = getprop("/Suzuki-GSX-R/"~pa~"/sector["~n~"]/fastest-time") or 0;
		var at = getprop("/sim/time/elapsed-sec") or 0;
		var ct = 0;
		
		var thsec = thissector.getValue();
		thsec -= 1;
		if (thsec > size(sectors)-1) thsec = 0;
		if (thsec < 0) thsec = size(sectors)-1;

		if(thsec == n and racelap.getValue() > 0){
			race_win.fg = [1,1,0,1];
			ct = at - sts;
			if(show_it){
				race_win.write(show_helper(ct));
				if(show_l_or_f){
					race_win.write("["~show_helper(ft)~"]");
				}else{
					race_win.write("["~show_helper(lt)~"]");
				}
			} 
			lapt += ct;
			# only for mp
			sectortime.setValue(ct);
		}else{
			race_win.fg = [1,1,1,1];
			if(show_it){
				race_win.write(show_helper(lt));
				if(show_l_or_f){
					race_win.write("["~show_helper(ft)~"]");
				}else{
					race_win.write("["~show_helper(lt)~"]");
				}
			}
			if(thsec > n)lapt += lt;
		}

		n += 1;
		winpos += 100;
	}

	var fl = getprop("/Suzuki-GSX-R/"~pa~"/fastest-lap") or 0;
	var ll = getprop("/Suzuki-GSX-R/last-lap-time") or 0;
	var tr = (lapt > total_result()) ? lapt : total_result();
	if(show_it) {

		if(racelap.getValue() > 0){
			var race_win = screen.window.new( winpos + 15, -20, 2, 1.1 );
			race_win.fg = [1,1,1,1];
			race_win.write("# "~racelap.getValue()~".# "~show_helper(lapt));
			if(show_l_or_f){
				race_win.write("["~show_helper(fl)~"]");
			}else{
				race_win.write("["~show_helper(ll)~"]");
			}
			var race_win = screen.window.new( winpos + 160, -20, 1, 1.1 );
			race_win.fg = [1,1,1,1];
			race_win.write(show_helper(tr));
		}else{			
			var race_win = screen.window.new( winpos + 15, -20, 2, 1.1 );
			race_win.fg = [1,1,1,1];
			race_win.write("# 0.# "~show_helper(0));		
			if(show_l_or_f){
				race_win.write("["~show_helper(fl)~"]");
			}else{
				race_win.write("["~show_helper(ll)~"]");
			}
			var race_win = screen.window.new( winpos + 160, -20, 1, 1.1 );
			race_win.fg = [1,1,1,1];
			race_win.write(show_helper(0));
		}
	}
	# only for mp
	laptime.setValue(lapt);
	racetime.setValue(tr);
	
}

################# Find the sector marker on the Isle of Man ###############

var find_marker = func{
	
	var isLat = getprop("/position/latitude-deg") or 0;
	var isLon = getprop("/position/longitude-deg") or 0;
	var mypos = geo.Coord.new();
	mypos.set_latlon( isLat, isLon);
	
	var marker_wp_pos = geo.Coord.new();
	marker_wp_pos.set_latlon(wp1tt[0], wp1tt[1], wp1tt[2]);
	var dis_to_TT = marker_wp_pos.distance_to(mypos);
	
	marker_wp_pos.set_latlon(wp1s[0], wp1s[1], wp1s[2]);
	var dis_to_S100 = marker_wp_pos.distance_to(mypos);
	
	marker_wp_pos.set_latlon(wp1nw[0], wp1nw[1], wp1nw[2]);
	var dis_to_NW200 = marker_wp_pos.distance_to(mypos);	
	
	marker_wp_pos.set_latlon(wp1ugp[0], wp1ugp[1]);
	var dis_to_UGP = marker_wp_pos.distance_to(mypos);
	
	marker_wp_pos.set_latlon(wp1mgp[0], wp1mgp[1], wp1mgp[2]);
	var dis_to_MGP = marker_wp_pos.distance_to(mypos);
	
	marker_wp_pos.set_latlon(wp1kal[0], wp1kal[1], wp1kal[2]);
	var dis_to_KAL = marker_wp_pos.distance_to(mypos);
	
	marker_wp_pos.set_latlon(wp1hd[0], wp1hd[1]);
	var dis_to_HD = marker_wp_pos.distance_to(mypos);
	
	marker_wp_pos.set_latlon(wp1cc[0], wp1cc[1]);
	var dis_to_CC = marker_wp_pos.distance_to(mypos);
	
	marker_wp_pos.set_latlon(wp1ct[0], wp1ct[1], wp1ct[2]);
	var dis_to_CT = marker_wp_pos.distance_to(mypos);
		
	if(dis_to_TT < 10000){   # if we are far away - 10km - from the Isle of Man stop script
		#print("We are on the Isle of Man");
		sectors = sectors_tt;
		pa = "TT";
	}else if(dis_to_S100 < 10000){
		#print("Welcome to Billown Circuit on the Isle of Man");
		sectors = sectors_s100;
		pa = "S100";
	}else if(dis_to_NW200 < 10000){
		#print("Welcome to North Ireland");
		sectors = sectors_nw200;
		pa = "NW200";
	}else if(dis_to_UGP < 10000){
		#print("Start up at the Ulster Grand Prix");
		sectors = sectors_ugp;
		pa = "UGP";
	}else if(dis_to_MGP < 10000){
		#print("Best wishes for the Macau Grand Prix");
		sectors = sectors_mgp;
		pa = "MGP";
	}else if(dis_to_KAL < 10000){
		#print("Remember Joey Dunlop");
		sectors = sectors_kal;
		pa = "KAL";
	}else if(dis_to_HD < 10000){
		#print("Hampton Downs Welcome");
		sectors = sectors_hd;
		pa = "HD";
	}else if(dis_to_CC < 10000){
		#print("Wanganui - Cimetery Circuit - New Zealand");
		sectors = sectors_cc;
		pa = "CC";
	}else if(dis_to_CT < 10000){
		#print("Terlicko - Czech");
		sectors = sectors_ct;
		pa = "CT";
	}

	# newbies have red jackets
	var p = size(sectors)-1;
	if(getprop("/Suzuki-GSX-R/"~pa~"/sector["~p~"]/fastest-time") == 0){
		setprop("sim/multiplay/generic/int[0]", 1);
	}else{
		setprop("sim/multiplay/generic/int[0]", 0);
	}
	
	if(thissector.getValue() > size(sectors)-1){
		thissector.setValue(0);
	}
	var ln = thissector.getValue()-1;
	if(ln < 0) { 
		ln = size(sectors)-1;
	}

	var marker_wp_pos = geo.Coord.new();
	marker_wp_pos.set_latlon(sectors[thissector.getValue()][0], sectors[thissector.getValue()][1], sectors[thissector.getValue()][2]);
	var wp_distance = marker_wp_pos.distance_to(mypos);
	
	# startsignal
	if(wp_distance < 50 or thissector.getValue() > 0 or racelap.getValue() > 0){
		setprop("/startsignal", 7);
	}else if(wp_distance < 60){
		setprop("/startsignal", 5);
	}else if(wp_distance < 65){
		setprop("/startsignal", 4);
	}else if(wp_distance < 70){
		setprop("/startsignal", 3);
	}else if(wp_distance < 75){
		setprop("/startsignal", 2);
	}else if(wp_distance < 80){
		setprop("/startsignal", 1);
	}
	
	# flag info for mp events
	if(wp_distance < 260){
		var courserl = getprop("/Suzuki-GSX-R/"~pa~"/race-laps") or 0;
	
		if(racelap.getValue() == courserl-1 ) { 
		    # courserl - 1 cause the marshall is placed before the start line
			flaginfo.setValue(6); #last round
		}else if (racelap.getValue() == courserl) {
			flaginfo.setValue(7);
		}else if (racelap.getValue() == courserl+1) {
			flaginfo.setValue(8);
		}else{
			flaginfo.setValue(0);
		}
	}

	if(wp_distance < 50){
		setprop("/Suzuki-GSX-R/"~pa~"/sector["~thissector.getValue()~"]/start-time", getprop("/sim/time/elapsed-sec"));
		#print ("Sie ueberfuhren den "~thissector.getValue()~". Wegpunkt "~sectors[thissector.getValue()][3]);
		setprop("/Suzuki-GSX-R/sector",sectors[thissector.getValue()][3]);

		var fastesttime = getprop("/Suzuki-GSX-R/"~pa~"/sector["~ln~"]/fastest-time") or 0;
		var lastsectorstarttime = getprop("/Suzuki-GSX-R/"~pa~"/sector["~ln~"]/start-time") or 0;
		var lastsectorendtime = getprop("/Suzuki-GSX-R/"~pa~"/sector["~thissector.getValue()~"]/start-time") or 0;
		var lasttime = (lastsectorstarttime != 0 and lastsectorendtime !=0 and (lastsectorendtime - lastsectorstarttime) > 0 ) ? lastsectorendtime - lastsectorstarttime : 0;
		setprop("/Suzuki-GSX-R/"~pa~"/sector["~ln~"]/last-time", lasttime);
		if(lasttime > 0 and lasttime < fastesttime or fastesttime == 0) setprop("/Suzuki-GSX-R/"~pa~"/sector["~ln~"]/fastest-time", lasttime);
		
		if(thissector.getValue() == 0){
		  # back at the first race wp
		  var n = 0;
		  var totallapresult = 0;
		  foreach(var ls; sectors) { 
		  	totallapresult += getprop("/Suzuki-GSX-R/"~pa~"/sector["~n~"]/last-time") or 0;
			n+=1;
		  }
		  setprop("/Suzuki-GSX-R/last-lap-time", totallapresult);
		  var fastestlap = getprop("/Suzuki-GSX-R/"~pa~"/fastest-lap") or 0;
		  if(totallapresult > 0 and totallapresult < fastestlap or fastestlap == 0) setprop("/Suzuki-GSX-R/"~pa~"/fastest-lap", totallapresult);
		  setprop("/Suzuki-GSX-R/"~pa~"/lap["~racelap.getValue()~"]/actual-time", totallapresult);
		  racelap.setValue(racelap.getValue() + 1);
		}
		
		thissector.setValue(thissector.getValue() + 1);
	}

	if(wp_distance < 50000){   # if we are far away - 50km - from the Race Course stop script
		inrange = 1;
		show_lap_and_sector_time();
		settimer(find_marker, 1.1);
	}else{
		inrange = 0;
	}
}

###################### START RESULT CALCULATION ###########################

find_marker();


var clear_race_datas = func{

	if(pa != nil and inrange != nil and inrange == 1){
		flaginfo.setValue(0);
		racelap.setValue(0);
		thissector.setValue(0);
		sectortime.setValue(0);
		laptime.setValue(0);
		racetime.setValue(0);
		var act = props.globals.getNode("/Suzuki-GSX-R/"~pa);
		
		setprop("/Suzuki-GSX-R/last-lap-time",0);
		
		foreach(var sector;act.getChildren("sector")){
			sector.getChild("start-time").setValue(0);
			sector.getChild("last-time").setValue(0);
		}
		
		foreach(var lap;act.getChildren("lap")){
			lap.getChild("actual-time").setValue(0);
		}
		
		screen.log.write("Start a new race now!", 0.0, 1.0, 0.0);
		
	}else{
		screen.log.write("Ups, NO racetrack in range!", 1.0, 0.0, 0.0);
	}

}

