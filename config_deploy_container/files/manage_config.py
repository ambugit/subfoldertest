#!/usr/bin/python

from pathlib import Path
import sys
import argparse
import yaml

class GetKeyValue(object):
    def main(self,args):

	key = args.key
	value = args.value
	config_file = args.config_file
	get_flag = args.get
	set_flag = args.set

	config_data = {}
	get_value = ""
	
	if set_flag and get_flag:
	         raise LookupError("<< Both --set and --get can not be used together.please use either of them.>>")	


	if set_flag :
		file_path_check = Path(config_file)
		if file_path_check.exists():

			val_dict = {}
			with open(config_file, 'r') as outfile:
                       		val_dict =  yaml.safe_load(outfile)
			
			val_dict.update({key:value})

			with open(config_file, 'w') as outfile:
    				yaml.dump(val_dict, outfile, default_flow_style=False)

		else:

			config_data[key]= value

                        with open(config_file, 'w') as outfile:
                                yaml.dump(config_data, outfile, default_flow_style=False)

		return value
	if get_flag:
		value_dict = {}
		with open(config_file, 'r') as outfile:
                       value_dict =  yaml.safe_load(outfile)
		if value_dict.has_key(key):
			get_value = value_dict[key]

			return get_value
		else:

			 raise LookupError("<< Key not found! Please enter the correct key...>>")
	return get_value
if __name__ == '__main__':
	#print(sys.argv)
	parser = argparse.ArgumentParser(description=__file__)
	parser.add_argument('--set',action='store_true')
	parser.add_argument('--get',action='store_true')
	parser.add_argument('--key', required=True)
	parser.add_argument('--value', required=False)
	parser.add_argument('--config_file', required=True)
	args = parser.parse_args()
	obj = GetKeyValue()
	val = obj.main(args)
	#print"value is :",val
	sys.exit(0)

