import subprocess
import sys

output_mode = 'player_title'
# print(sys.argv)
if len(sys.argv)>1 and sys.argv[2] == 'name':
    output_mode = 'player_name'

result = subprocess.run('playerctl -al', shell=True, text=True, capture_output=True)

def get_player_stat(player:str):
    stat = subprocess.run(f'playerctl --player={player} status', shell=True, text=True, capture_output=True)
    if stat.returncode:
        return None
    return stat.stdout
def get_player_title(player:str):
    title = subprocess.run(f'playerctl --player={player} metadata title', shell=True, text=True, capture_output=True)
    if title.returncode:
        return None
    return title.stdout

for player in result.stdout.splitlines():
    stat = get_player_stat(player)
    # print(stat)
    if 'Playing' in stat:
        if output_mode == 'player_title':        
            print(get_player_title(player))
        else:
            print(player)
        break
else:
    if output_mode == 'player_title':
        print(get_player_title(result.stdout.splitlines()[0]))
    else:
        print(result.stdout.splitlines()[0])
