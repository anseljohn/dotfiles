for i in `ls -d */`;
do
    ( stow --restow $i )
done

dkaopdwk