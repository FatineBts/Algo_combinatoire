
CC = gcc
CFLAGS = -O3 -Wall
END = -lm

wds_smt_timing: wds_smt_timing.c
	$(CC) $(CFLAGS) -o $@ $^ $(END)

wds_smt_org: wds_smt_org.c
	$(CC) $(CFLAGS) -o $@ $^ $(END)

clean:
	rm -f wds_smt_timing wds_smt_org
