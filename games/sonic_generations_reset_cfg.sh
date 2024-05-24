#sonic generations sometimes has problems startign up related to the cfg files
#this just deletes them so it can be recreated on startup


#use proton experimental
#gamemoderun PROTON_NO_FSYNC=1 PROTON_NO_ESYNC=1 PROTON_USE_D9VK=1

rm "/home/shared_steam/steamapps/common/Sonic Generations/*.cfg"
