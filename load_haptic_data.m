infos_filename = '/home/bhigy/data/experiments/20150527_1000/imginfos/data.log';
imginfos = Imginfos(infos_filename);
[sequences labels] = get_sequences(imginfos);

haptic_filename = '/home/bhigy/data/experiments/20150527_1000/left_arm/data.log';
haptic_data = load(haptic_filename);